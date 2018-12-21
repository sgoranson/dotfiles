#!/usr/bin/env python3

import sys, os, random
import pdb

do_c = False
do_j = True
do_t = False


imgdir = sys.argv[1]
if len(sys.argv) == 3 and sys.argv[2] == 'j':
    do_j = True
    do_c = False

# pdb.set_trace()
gifxs = os.listdir(imgdir)

# thumb_root_path = os.path.join(imgdir, 'thumbs/', thumbsize)


all_images = []

for gif_file in gifxs:

    gif_path = os.path.join(imgdir, gif_file)
    if os.path.isdir(gif_path):
        continue

    all_images.append(gif_path)

if do_j:
    print('let PICS = ', end='')
    print(all_images)

elif do_c:
    max_col_size = int(len(all_images) / 4)

# print('SPG: {} {}'.format(len(all_images),max_col_size))
    print('<div class="row">')
    print('<div class="column">')

    for i, pic in enumerate(all_images):
        if (i != 0) and (i % max_col_size == 0):
            print('</div>')
            print('<div class="column">')

        print('<img src="{}" style="width:100%">'.format(pic))

    print('</div>')
    print('</div>')

elif do_t:
    print('not implemented')
    # thumb_file = os.path.join(thumb_root_path, 's_' + gif_file)

    # cmd = 'convert -thumbnail x' + thumbsize + ' ' + gif_path + ' ' + thumb_file

    # print('running "' + cmd + '"')
    # ret = os.system(cmd)

    # if ret != 0:
    #     print('cmd failed: ' + cmd)

