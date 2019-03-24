#!/usr/bin/env python3

# Copyright (C) 2012-2019  Xyne
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# (version 2) as published by the Free Software Foundation.
#
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

import argparse
import calendar
import datetime
import errno
import getpass
import http.client
import itertools
import json
import logging
import os
import pipes
import queue
import re
import socket
import subprocess
import sys
import tempfile
import threading
import time
import urllib.error
import urllib.request

################################## Constants ###################################

NAME = 'Reflector'

URL = 'https://www.archlinux.org/mirrors/status/json/'

DISPLAY_TIME_FORMAT = '%Y-%m-%d %H:%M:%S UTC'
PARSE_TIME_FORMAT = '%Y-%m-%dT%H:%M:%SZ'
PARSE_TIME_FORMAT_WITH_USEC = '%Y-%m-%dT%H:%M:%S.%fZ'

DB_SUBPATH = 'core/os/x86_64/core.db'

MIRROR_URL_FORMAT = '{0}{1}/os/{2}'
MIRRORLIST_ENTRY_FORMAT = "Server = " + MIRROR_URL_FORMAT + "\n"

DEFAULT_CONNECTION_TIMEOUT = 5
DEFAULT_CACHE_TIMEOUT = 300
DEFAULT_N_THREADS = 5

SORT_TYPES = {
  'age'    : 'last server synchronization',
  'rate'   : 'download rate',
  'country': 'server\'s location',
  'score'  : 'MirrorStatus score',
  'delay'  : 'MirrorStatus delay',
}


################################# IO Functions #################################

def get_cache_file():
  '''
  Get a nearly XDG-compliant cache directory. PyXDG is not used to  avoid the
  external dependency. It is not fully compliant because it omits the
  application name, but the mirror status file can be reused by other
  applications and this stores no other files.
  '''
  base_name = 'mirrorstatus.json'
  cache_dir = os.getenv('XDG_CACHE_HOME', default=os.path.expanduser('~/.cache'))
  try:
    os.makedirs(cache_dir, exist_ok=True)
  # Raised by makedirs if permissions do not match umask
  except FileExistsError:
    pass
  return os.path.join(cache_dir, base_name)



def get_mirrorstatus(
  connection_timeout=DEFAULT_CONNECTION_TIMEOUT,
  cache_timeout=DEFAULT_CACHE_TIMEOUT
):
  '''
  Retrieve the mirror status JSON object. The downloaded data will be cached
  locally and re-used within the cache timeout period. Returns the object and
  the local cache's modification time.
  '''
  cache_path = get_cache_file()
  try:
    mtime = os.path.getmtime(cache_path)
    invalid = (time.time() - mtime) > cache_timeout
  except FileNotFoundError:
    mtime = None
    invalid = True

  try:
    if invalid:
      with urllib.request.urlopen(URL, None, connection_timeout) as h:
        obj = json.loads(h.read().decode())
      with open(cache_path, 'w') as h:
        json.dump(obj, h, sort_keys=True, indent=2)
      mtime = time.time()
    else:
      with open(cache_path, 'r') as h:
        obj = json.load(h)

    return obj, mtime
  except (IOError, urllib.error.URLError, socket.timeout) as e:
    raise MirrorStatusError(str(e))



################################ Miscellaneous #################################

def get_logger():
  '''
  Get the logger used by this module. Use this to be sure that the right logger
  is used.
  '''
  return logging.getLogger(NAME)



def format_last_sync(mirrors):
  '''
  Parse and format the "last_sync" field.
  '''
  for m in mirrors:
    last_sync = calendar.timegm(time.strptime(m['last_sync'], PARSE_TIME_FORMAT))
    m.update(last_sync=last_sync)
    yield m



def count_countries(mirrors):
  '''
  Count the mirrors in each country.
  '''
  countries = dict()
  for m in mirrors:
    k = (m['country'], m['country_code'])
    if not any(k):
      continue
    try:
      countries[k] += 1
    except KeyError:
      countries[k] = 1
  return countries



################################### Sorting ####################################

def sort(mirrors, by=None, n_threads=DEFAULT_N_THREADS):
  '''
  Sort mirrors by different criteria.
  '''
  # Ensure that "mirrors" is a list that can be sorted.
  if not isinstance(mirrors, list):
    mirrors = list(mirrors)

  if by == 'age':
    mirrors.sort(key=lambda m: m['last_sync'], reverse=True)

  elif by == 'rate':
    rates = rate(mirrors, n_threads=n_threads)
    mirrors = sorted(mirrors, key=lambda m: rates[m['url']], reverse=True)

  else:
    try:
      mirrors.sort(key=lambda m: m[by])
    except KeyError:
      raise MirrorStatusError('attempted to sort mirrors by unrecognized criterion: "{}"'.format(by))

  return mirrors


#################################### Rating ####################################

def rate_rsync(db_url, connection_timeout=DEFAULT_CONNECTION_TIMEOUT):
  '''
  Download a database via rsync and return the time and rate of the download.
  '''
  rsync_cmd = [
    'rsync',
    '-avL', '--no-h', '--no-motd',
    '--contimeout={}'.format(connection_timeout),
    db_url
  ]
  try:
    with tempfile.TemporaryDirectory() as tmpdir:
      t0 = time.time()
      subprocess.check_call(
        rsync_cmd + [tmpdir],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
      )
      dt = time.time() - t0
      size = os.path.getsize(
        os.path.join(tmpdir, os.path.basename(DB_SUBPATH))
      )
      r = size / dt
      return dt, r
  except (subprocess.CalledProcessError, subprocess.TimeoutExpired, FileNotFoundError):
    return 0, 0



def rate_http(db_url, connection_timeout=DEFAULT_CONNECTION_TIMEOUT):
  '''
  Download a database via any protocol supported by urlopen and return the time
  and rate of the download.
  '''
  req = urllib.request.Request(url=db_url)
  try:
    with urllib.request.urlopen(req, None, connection_timeout) as f:
      t0 = time.time()
      size = len(f.read())
      dt = time.time() - t0
    r = size / (dt)
    return dt, r
  except (OSError, urllib.error.HTTPError, http.client.HTTPException):
    return 0, 0



def rate(mirrors, n_threads=DEFAULT_N_THREADS, connection_timeout=DEFAULT_CONNECTION_TIMEOUT):
  '''
  Rate mirrors by timing the download the core repo's database for each one.
  '''
  # Ensure that mirrors is not a generator so that its length can be determined.
  if not isinstance(mirrors, tuple):
    mirrors = tuple(mirrors)

  if not mirrors:
    return None

  # At least 1 thread and not more than the number of mirrors.
  n_threads = max(1, min(n_threads, len(mirrors)))

  # URL input queue.
  q_in = queue.Queue()
  # URL, elapsed time and rate output queue.
  q_out = queue.Queue()


  def worker():
    while True:
      # To stop a thread, an integer will be inserted in the input queue. Each
      # thread will increment it and re-insert it until it equals the
      # threadcount. After encountering the integer, the thread exits the loop.
      url = q_in.get()

      if isinstance(url, int):
        if url < n_threads:
          q_in.put(url + 1)

      else:
        db_url = url + DB_SUBPATH
        scheme = urllib.parse.urlparse(url).scheme

        if scheme == 'rsync':
          dt, r = rate_rsync(db_url, connection_timeout)
        else:
          dt, r = rate_http(db_url, connection_timeout)

        q_out.put((url, dt, r))

      q_in.task_done()


  workers = tuple(threading.Thread(target=worker) for _ in range(n_threads))
  for w in workers:
    w.daemon = True
    w.start()

  url_len = max(len(m['url']) for m in mirrors)
  logger = get_logger()
  for m in mirrors:
    url = m['url']
    logger.info("rating {}".format(url))
    q_in.put(url)

  # To exit the threads.
  q_in.put(0)
  q_in.join()

  header_fmt = '{{:{:d}s}}  {{:>14s}}  {{:>9s}}'.format(url_len)
  logger.info(header_fmt.format('Server', 'Rate', 'Time'))
  fmt = '{{:{:d}s}}  {{:8.2f}} KiB/s  {{:7.2f}} s'.format(url_len)

  # Loop over the mirrors just to ensure that we get the rate for each mirror.
  # The value in the loop does not (necessarily) correspond to the mirror.
  rates = dict()
  for _ in mirrors:
    url, dt, r = q_out.get()
    kibps = r / 1024.0
    logger.info(fmt.format(url, kibps, dt))
    rates[url] = r
    q_out.task_done()

  return rates



############################## MirrorStatusError ###############################

class MirrorStatusError(Exception):
  '''
  Common base exception raised by this module.
  '''
  def __init__(self, msg):
    self.msg = msg
  def __str__(self):
    return repr(self.msg)




############################## MirrorStatusFilter ##############################

class MirrorStatusFilter():

  def __init__(
    self,
    min_completion_pct=1.0,
    countries=None,
    protocols=None,
    include=None,
    exclude=None,
    age=None,
    isos=False,
    ipv4=False,
    ipv6=False
  ):
    self.min_completion_pct = min_completion_pct
    self.countries = tuple(c.upper() for c in countries) if countries else None
    self.protocols = protocols
    self.include = tuple(re.compile(r) for r in include) if include else None
    self.exclude = tuple(re.compile(r) for r in exclude) if exclude else None
    self.age = age
    self.isos = isos
    self.ipv4 = ipv4
    self.ipv6 = ipv6


  def filter_mirrors(self, mirrors):
    # Filter unsynced mirrors.
    mirrors = (m for m in mirrors if m['last_sync'])

    # Parse the last sync time.
    mirrors = format_last_sync(mirrors)

    # Filter by completion "percent" [0-1].
    mirrors = (m for m in mirrors if m['completion_pct'] >= self.min_completion_pct)

    # Filter by countries.
    if self.countries:
      mirrors = (
        m for m in mirrors
        if m['country'].upper() in self.countries
        or m['country_code'].upper() in self.countries
      )

    # Filter by protocols.
    if self.protocols:
      mirrors = (m for m in mirrors if m['protocol'] in self.protocols)

    # Filter by include expressions.
    if self.include:
      mirrors = (m for m in mirrors if any(r.search(m['url']) for r in self.include))

    # Filter by exclude expressions.
    if self.exclude:
      mirrors = (m for m in mirrors if not any(r.search(m['url']) for r in self.exclude))

    # Filter by age. The age is given in hours and converted to seconds. Servers
    # with a last refresh older than the age are omitted.
    if self.age and self.age > 0:
      t = time.time()
      a = self.age * 60**2
      mirrors = (m for m in mirrors if (m['last_sync'] + a) >= t)

    # The following does not work. Only the final iteration affects "mirrors".
    # TODO: Understand exactly why the code above works but the loop doesn't.
    #  for field in ('isos', 'ipv4', 'ipv6'):
    #    if getattr(self, field):
    #      mirrors = (m for m in mirrors if m[field])

    # Filter by ISO hosing.
    if self.isos:
      mirrors = (m for m in mirrors if m['isos'])

    # Filter by IPv4 support.
    if self.ipv4:
      mirrors = (m for m in mirrors if m['ipv4'])

    # Filter by IPv6 support.
    if self.ipv6:
      mirrors = (m for m in mirrors if m['ipv6'])

    yield from mirrors



################################## Formatting ##################################

def format_mirrorlist(mirror_status, mtime, include_country=False, command=None):
  if command is None:
    command = '?'
  else:
    command = 'reflector ' + ' '.join(pipes.quote(x) for x in command)

  last_check = mirror_status['last_check']
  # For some reason the "last_check" field included microseconds.
  try:
    parsed_last_check = datetime.datetime.strptime(
      last_check,
      PARSE_TIME_FORMAT_WITH_USEC,
    ).timetuple()
  except ValueError:
    parsed_last_check = datetime.datetime.strptime(
      last_check,
      PARSE_TIME_FORMAT,
    ).timetuple()

  width = 80
  colw = 11
  header = '# Arch Linux mirrorlist generated by Reflector #'.center(width, '#')
  border = '#' * len(header)
  mirrorlist = ''
  mirrorlist = '{}\n{}\n{}\n'.format(border, header, border) + \
    '\n' + \
    '\n'.join(
      '# {{:<{:d}s}} {{}}'.format(colw).format(k, v) for k, v in (
        ('With:', command),
        ('When:', time.strftime(DISPLAY_TIME_FORMAT, time.gmtime())),
        ('From:', URL),
        ('Retrieved:', time.strftime(DISPLAY_TIME_FORMAT, time.gmtime(mtime))),
        ('Last Check:', time.strftime(DISPLAY_TIME_FORMAT, parsed_last_check))
      )
    ) + \
    '\n\n'

  country = None

  mirrors = mirror_status['urls']
  for mirror in mirrors:
    # Include country tags. This is intended for lists that are sorted by
    # country.
    if include_country:
      c = '{} [{}]'.format(mirror['country'], mirror['country_code'])
      if c != country:
        if country:
          mirrorlist += '\n'
        mirrorlist += '# {}\n'.format(c)
        country = c
    mirrorlist += MIRRORLIST_ENTRY_FORMAT.format(mirror['url'], '$repo', '$arch')

  if mirrors:
    return mirrorlist
  else:
    return None





############################ MirrorStatus Retriever ############################

class MirrorStatus():
  '''
  This is a legacy class that will likely be removed in the future. It
  previously held most of this module's functionality until it was refactored
  into more modular functions. Seemingly pointless code is still used by
  importers of this module.
  '''

  # TODO: move these to another module or remove them completely
  # Related: https://bugs.archlinux.org/task/32895
  REPOSITORIES = (
    'community',
    'community-staging',
    'community-testing',
    'core',
    'extra',
    'gnome-unstable',
    'kde-unstable',
    'multilib',
    'multilib-testing'
    'staging',
    'testing'
  )
  # Officially supported system architectures.
  ARCHITECTURES = ['x86_64']

  MIRROR_URL_FORMAT = MIRROR_URL_FORMAT
  MIRRORLIST_ENTRY_FORMAT = MIRRORLIST_ENTRY_FORMAT


  def __init__(
    self,
    connection_timeout=DEFAULT_CONNECTION_TIMEOUT,
    cache_timeout=DEFAULT_CACHE_TIMEOUT,
    min_completion_pct=1.0,
    threads=DEFAULT_N_THREADS
  ):
    self.connection_timeout = connection_timeout
    self.cache_timeout = cache_timeout
    self.min_completion_pct = min_completion_pct
    self.threads = threads

    self.mirror_status = None
    self.ms_mtime = 0


  def retrieve(self):
    self.mirror_status, self.ms_mtime = get_mirrorstatus(
      connection_timeout=self.connection_timeout,
      cache_timeout=self.cache_timeout
    )


  def get_obj(self):
    '''
    Get the JSON mirror status.
    '''
    t = time.time()
    if (t - self.ms_mtime) > self.cache_timeout:
      self.retrieve()
    return self.mirror_status


  def get_mirrors(self):
    '''
    Get the mirror from the mirror status.
    '''
    obj = self.get_obj()
    try:
      return obj['urls']
    except KeyError:
      raise MirrorStatusError('no mirrors detected in mirror status output')



  def filter(self, mirrors=None, **kwargs):
    '''
    Filter mirrors by various criteria.
    '''
    if mirrors is None:
      mirrors = self.get_mirrors()
    msf = MirrorStatusFilter(min_completion_pct=self.min_completion_pct, **kwargs)
    yield from msf.filter_mirrors(mirrors)



  def sort(self, mirrors=None, **kwargs):
    '''
    Sort mirrors by various criteria.
    '''
    if mirrors is None:
      mirrors = self.get_mirrors()
    yield from sort(mirrors, n_threads=self.threads, **kwargs)


  def rate(self, mirrors=None, **kwargs):
    '''
    Sort mirrors by download speed.
    '''
    if mirrors is None:
      mirrors = self.get_mirrors()
    yield from sort(mirrors, n_threads=self.threads, by='rate', **kwargs)



  def display_time(self, t=None):
    '''Format a time for display.'''
    return time.strftime(self.DISPLAY_TIME_FORMAT, t)



  def get_mirrorlist(self, mirrors=None, include_country=False, cmd=None):
    '''
    Get a Pacman-formatted mirrorlist.
    '''
    obj = self.get_obj().copy()
    if mirrors is not None:
      if not isinstance(mirrors, list):
        mirrors = list(mirrors)
      obj['urls'] = mirrors
    return format_mirrorlist(obj, self.ms_mtime, include_country=include_country, command=cmd)



  def list_countries(self):
    '''
    List countries along with a server count for each one.
    '''
    mirrors = self.get_mirrors()
    return count_countries(mirrors)



############################### argparse Actions ###############################

class ListCountries(argparse.Action):
  '''
  Action to list countries along with the number of mirrors in each.
  '''
  def __call__(self, parser, namespace, values, option_string=None):
    ms = MirrorStatus()
    countries = ms.list_countries()
    w = max(len(c) for c, cc in countries)
    n = len(str(max(countries.values())))
    fmt = '{{:{:d}s}} {{}} {{:{:d}d}}'.format(w, n)
    for (c, cc), n in sorted(countries.items(), key=lambda x: x[0][0]):
      print(fmt.format(c, cc, n))
    sys.exit(0)



def print_mirror_info(mirrors, time_fmt=DISPLAY_TIME_FORMAT):
  '''
  Print information about each mirror to STDOUT.
  '''
  if mirrors:
    #  mirrors = format_last_sync(mirrors)
    if not isinstance(mirrors, list):
      mirrors = list(mirrors)
    ks = sorted(k for k in mirrors[0].keys() if k != 'url')
    l = max(len(k) for k in ks)
    fmt = '{{:{:d}s}} : {{}}'.format(l)
    for m in mirrors:
      print('{}$repo/os/$arch'.format(m['url']))
      for k in ks:
        v = m[k]
        if k == 'last_sync':
          v = time.strftime(time_fmt, time.gmtime(v))
        print(fmt.format(k, v))
      print()



def add_arguments(parser):
  '''
  Add reflector arguments to the argument parser.
  '''
  parser = argparse.ArgumentParser(description='retrieve and filter a list of the latest Arch Linux mirrors')

  parser.add_argument(
    '--connection-timeout', type=int, metavar='n', default=DEFAULT_CONNECTION_TIMEOUT,
    help='The number of seconds to wait before a connection times out. Default: %(default)s'
  )

#   parser.add_argument(
#     '--download-timeout', type=int, metavar='n',
#     help='The number of seconds to wait before a download times out. The threshold is checked after each chunk is read, so the actual timeout may take longer.'
#   )

  parser.add_argument(
    '--list-countries', action=ListCountries, nargs=0,
    help='Display a table of the distribution of servers by country.'
  )

  parser.add_argument(
    '--cache-timeout', type=int, metavar='n', default=DEFAULT_CACHE_TIMEOUT,
    help='The cache timeout in seconds for the data retrieved from the Arch Linux Mirror Status API. The default is %(default)s.'
  )

  parser.add_argument(
    '--save', metavar='<filepath>',
    help='Save the mirrorlist to the given path.'
  )

  sort_help = '; '.join('"{}": {}'.format(k, v) for k, v in SORT_TYPES.items())
  parser.add_argument(
    '--sort', choices=SORT_TYPES,
    help='Sort the mirrorlist. {}.'.format(sort_help)
  )

  parser.add_argument(
    '--threads', type=int, metavar='n', default=DEFAULT_N_THREADS,
    help='The maximum number of threads to use when rating mirrors. Default: %(default)s'
  )

  parser.add_argument(
    '--verbose', action='store_true',
    help='Print extra information to STDERR. Only works with some options.'
  )

  parser.add_argument(
    '--info', action='store_true',
    help='Print mirror information instead of a mirror list. Filter options apply.'
  )



  filters = parser.add_argument_group(
    'filters',
    'The following filters are inclusive, i.e. the returned list will only contain mirrors for which all of the given conditions are met.'
  )

  filters.add_argument(
    '-a', '--age', type=float, metavar='n',
    help='Only return mirrors that have synchronized in the last n hours. n may be an integer or a decimal number.'
  )

  filters.add_argument(
    '-c', '--country', dest='countries', action='append', metavar='<country>',
    help='Match one of the given countries (case-sensitive). Use "--list-countries" to see which are available.'
  )

  filters.add_argument(
    '-f', '--fastest', type=int, metavar='n',
    help='Return the n fastest mirrors that meet the other criteria. Do not use this option without other filtering options.'
  )

  filters.add_argument(
    '-i', '--include', metavar='<regex>', action='append',
    help='Include servers that match <regex>, where <regex> is a Python regular express.'
  )

  filters.add_argument(
    '-x', '--exclude', metavar='<regex>', action='append',
    help='Exclude servers that match <regex>, where <regex> is a Python regular express.'
  )

  filters.add_argument(
    '-l', '--latest', type=int, metavar='n',
    help='Limit the list to the n most recently synchronized servers.'
  )

  filters.add_argument(
    '--score', type=int, metavar='n',
    help='Limit the list to the n servers with the highest score.'
  )

  filters.add_argument(
    '-n', '--number', type=int, metavar='n',
    help='Return at most n mirrors.'
  )

  filters.add_argument(
    '-p', '--protocol', dest='protocols', action='append', metavar='<protocol>',
    help='Match one of the given protocols, e.g. "http", "ftp".'
  )

  filters.add_argument(
    '--completion-percent', type=float, metavar='[0-100]', default=100.,
    help='Set the minimum completion percent for the returned mirrors. Check the mirrorstatus webpage for the meaning of this parameter. Default value: %(default)s.'
  )

  filters.add_argument(
    '--isos', action='store_true',
    help='Only return mirrors that host ISOs.'
  )

  filters.add_argument(
    '--ipv4', action='store_true',
    help='Only return mirrors that support IPv4.'
  )

  filters.add_argument(
    '--ipv6', action='store_true',
    help='Only return mirrors that support IPv6.'
  )

  return parser



def parse_args(args=None):
  '''
  Parse command-line arguments.
  '''
  parser = argparse.ArgumentParser(
    description='retrieve and filter a list of the latest Arch Linux mirrors'
  )
  parser = add_arguments(parser)
  options = parser.parse_args(args)
  return options



# Process options
def process_options(options, ms=None, mirrors=None):
  '''
  Process options.

  Optionally accepts a MirrorStatus object and/or the mirrors as returned by
  the MirrorStatus.get_mirrors method.
  '''
  if not ms:
    ms = MirrorStatus(
      connection_timeout=options.connection_timeout,
#       download_timeout=options.download_timeout,
      cache_timeout=options.cache_timeout,
      min_completion_pct=(options.completion_percent/100.),
      threads=options.threads
    )

  if mirrors is None:
    mirrors = ms.get_mirrors()

  # Filter
  mirrors = ms.filter(
    mirrors,
    countries=options.countries,
    include=options.include,
    exclude=options.exclude,
    age=options.age,
    protocols=options.protocols,
    isos=options.isos,
    ipv4=options.ipv4,
    ipv6=options.ipv6
  )

  if options.latest and options.latest > 0:
    mirrors = ms.sort(mirrors, by='age')
    mirrors = itertools.islice(mirrors, options.latest)

  if options.score and options.score > 0:
    mirrors = ms.sort(mirrors, by='score')
    mirrors = itertools.islice(mirrors, options.score)

  if options.fastest and options.fastest > 0:
    mirrors = ms.sort(mirrors, by='rate')
    mirrors = itertools.islice(mirrors, options.fastest)

  if options.sort and not (options.sort == 'rate' and options.fastest):
    mirrors = ms.sort(mirrors, by=options.sort)

  if options.number:
    mirrors = list(mirrors)[:options.number]

  return ms, mirrors



def main(args=None, configure_logging=False):
  if args:
    cmd = tuple(args)
  else:
    cmd = sys.argv[1:]

  options = parse_args(args)

  # Configure logging.
  logger = get_logger()

  if configure_logging:
    if options.verbose:
      level = logging.INFO
    else:
      level = logging.WARNING

    logger.setLevel(level)
    ch = logging.StreamHandler()
    formatter = logging.Formatter(
      fmt='[{asctime:s}] {levelname:s}: {message:s}',
      style='{',
      datefmt='%Y-%m-%d %H:%M:%S'
    )
    ch.setFormatter(formatter)
    logger.addHandler(ch)


  try:
    ms, mirrors = process_options(options)
    if mirrors is not None and not isinstance(mirrors, list):
      mirrors = list(mirrors)
    if not mirrors:
      sys.exit('error: no mirrors found')
    include_country = options.sort == 'country'
    # Convert the generator object to a list for re-use later.
    if options.info:
      print_mirror_info(mirrors)
      return
    else:
      mirrorlist = ms.get_mirrorlist(mirrors, include_country=include_country, cmd=cmd)
      if mirrorlist is None:
        sys.exit('error: no mirrors found')
  except MirrorStatusError as e:
    sys.exit('error: {}\n'.format(e.msg))

  if options.save:
    try:
      with open(options.save, 'w') as f:
        f.write(mirrorlist)
    except IOError as e:
      sys.exit('error: {}\n'.format(e.strerror))
  else:
    print(mirrorlist)



def run_main(args=None, **kwargs):
  try:
    main(args, **kwargs)
  except KeyboardInterrupt:
    pass


if __name__ == "__main__":
  run_main(configure_logging=True)

