# -*- coding: utf-8 -*-
#
import subprocess
import os
import os.path

import os

from i3pystatus import Status

from i3pystatus.weather import weathercom
from i3pystatus.updates import pacman, cower

# Prog Variable
terminal = "kitty"
filemanager = "pcmanfm"

color00 = '#1c1c1c'
color01 = '#af005f'
color02 = '#5fafd7'
color03 = '#d7af5f'
color04 = '#5fafd7'
color05 = '#808080'
color06 = '#d7875f'
color07 = '#d0d0d0'
color08 = '#585858'
color09 = '#d7af00'
color10 = '#afd700'
color11 = '#af87d7'
color12 = '#ffaf00'
color13 = '#ff5faf'
color14 = '#00afaf'
color15 = '#5f8787'
color16 = '#5fafd7'
color17 = '#5faf5f'

# color00 = '#01959F'
# color01 = '#01959F'
# color02 = '#01959F'
# color03 = '#01959F'
# color04 = '#01959F'
# color05 = '#5E495A'
# color06 = '#5E495A'
# color07 = '#5E495A'
# color08 = '#5E495A'
# color09 = '#5E495A'
# color10 = '#E96058'
# color11 = '#E96058'
# color12 = '#E96058'
# color13 = '#E96058'
# color14 = '#E96058'
# color15 = '#E96058'

status = Status()

# CLOCK ---------------------------------------------------------------
status.register(
    "clock",
    hints={"markup": "pango"},
    format=
    "<span lang='clock' weight='normal' face='FontAwesome'></span> %a %e %I:%M:%S",
    color=color02,
    interval=1,
    # on_leftclick="zenity --calendar --text ''",
)

# CAL -----------------------------------------------------------------
# status.register("clock",

#format="  %a %d-%m-%Y ",
# color='#61AEEE',
# interval=1,

#   )

# ALSA SOUND ----------------------------------------------------------
# status.register(
#     "pulseaudio",
#     on_leftclick="amixer -D pulse set Master toggle",
#     # on_rightclick="pavucontrol",
#     # bar_type='horizontal',
#     color_muted='#EDBE9B',
#     color_unmuted='#BD1D00',
#     multi_colors=True,
#     format="vol {volume_bar}",
#     format_muted='vol [muted]',
# )
status.register(
    "alsa",
    on_leftclick="amixer -D pulse set Master toggle",
    # on_rightclick="pavucontrol",
    color=color03,
    color_muted=color01,
    format=" {volume}%",
    format_muted=' [muted]',
)

# status.register(
#     "network",
#     format_up="{essid}  {bytes_recv:3d} MB/s  {bytes_sent} MB/s",
#     # format_up="{network_graph}",
#     # graph_style="braille-fill",
#     # graph_width=30,
#     # color=color04,
#     format_down="NET DOWN",
#     interface="wlp3s0",
# )
# WIRRELESS -----------------------------------------------------------
# status.register("network",

#                interface="wlp3s0",
#                # color_up   = color,
#                #color_down  =networkFColor,
#                hints={"markup": "pango", "separator": True},
#                format_up="<span color='"+networkFColor+"' \
#                    >{essid} {bytes_recv:6.1f}K {bytes_sent:5.1f}K</span>",
#                format_down="<span color='"+networkFColor+"' ></span>",

#                # on_leftclick = "firefox"

#                )

# battery
status.register(
    'battery',
    format=' {percentage:.0f}%[ ({remaining})]',
    not_present_text="",
    alert=True,
    alert_percentage=5,
    color=color05,
    interval=5,
)

# TEMPIRATURE ---------------------------------------------------------
status.register(
    "temp",
    format=" {temp}°",
    #color        =tempFColor,
    color=color06,
    alert_color=color01,
    alert_temp=60,
)

# DISK USAGE ----------------------------------------------------------
# free disk space
status.register(
    "disk",
    color=color07,
    path="/",
    on_leftclick=filemanager,
    format="\u3000 {avail}G")

# MEMORY --------------------------------------------------------------
status.register(
    "mem",
    color=color08,
    warn_color=color11,
    alert_color=color01,
    format=' {percent_used_mem}%',
)
# cpu frequency
# status.register(
#     "cpu_freq",
#     format=" {avgg} Ghz",
#     color=color09,
# )
# load
# status.register(
#     "load",
#     format=' {avg1} {avg5} {avg15}',
#     color=color10,
#     critical_limit=6,
# )

# CPU USAGE -----------------------------------------------------------
status.register(
    "cpu_usage",
    on_leftclick=terminal + " -e 'htop'",
    format='  {usage:02d}%',
    dynamic_color=True,
    start_color=color11)
status.register(
    'cpu_usage_graph',
    # format=('CPU: ' + cpubarformat),
    format='{cpu_graph:<15}',
    # bar_type='vertical',
    dynamic_color=True,
    hints={'min_width': '__________________'},
)
# ping
# status.register(
#         "ping",
#         format="\uF079\u3000 {ping} ms",
#         format_down="unreachable",
#         color=color12,
#         )

status.register(
    'ping',
    format='128.sh → {ping:5.1f} ms',
    format_down="unreachable",
    color=color12,
    host='128.sh')

status.register('external_ip', format='wan:→ {ip}', color=color10, interval=60)

# status.register(
#     'net_speed',
#     format='↓{speed_down:.1f}{down_units} ↑{speed_up:.1f}{up_units}',
#     units='bytes',
#     interval=5,
# )

status.register(
    "shell",
    command="$HOME/bin/status/topcpu.sh",
    color=color04)

status.register(
    "network",
    interface="wlp0s20u2",
    format_up="↓{bytes_recv:3s} KB/s ↑{bytes_sent:3s} KB/s",
    divisor=(1024),
    # format_up="{essid}  {network_graph_recv}  {network_graph_sent}",
    dynamic_color=True,
    separate_color=True,
    start_color=color14,
    end_color=color15,
)
# status.register(
#     "network",
#     interface="wlp0s20u2",
#     # format_up="{essid} {quality}%  {bytes_recv:3s} MB/s  {bytes_sent} MB/s",
#     format_up="↓{network_graph_recv} ↑{network_graph_sent}",
#     #     # format_up="{essid}  {network_graph_recv}  {network_graph_sent}",
#     dynamic_color=True,
#     separate_color=True,
#     graph_width=10,
#     start_color=color14,
#     end_color=color15,
#     hints={'min_width': '________________'},
# )
# weather  ------------------------------------------------------------
# status.register(
#     'weather',
#     format='{current_temp}{temp_unit}[ {icon}][ {update_error}]',
#     colorize=True,
#     hints={'markup': 'pango'},
#     backend=weathercom.Weathercom(
#         location_code='USMA0502:1:US',
#         units='imperial',
#     ),
# )

status.run()
