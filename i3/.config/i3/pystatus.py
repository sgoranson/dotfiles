# -*- coding: utf-8 -*-
#
import subprocess
import os
import os.path

from i3pystatus import Status

from i3pystatus.weather import weathercom
from i3pystatus.updates import pacman, cower

# Prog Variable
terminal = "kitty"
filemanager = "pcmanfm"

color00 = '#1c1c1c'
color01 = '#af005f'
color02 = '#5faf00'
color03 = '#d7af5f'
color04 = '#5fafd7'
color05 = '#808080'
color06 = '#d7875f'
color07 = '#d0d0d0'
color08 = '#585858'
color09 = '#5faf5f'
color10 = '#afd700'
color11 = '#af87d7'
color12 = '#ffaf00'
color13 = '#ff5faf'
color14 = '#00afaf'
color15 = '#5f8787'
color16 = '#5fafd7'
color17 = '#d7af00'

status = Status()


# CLOCK ---------------------------------------------------------------
status.register(
    "clock",
    hints={"markup": "pango"},
    format=' %H:%M:%S',
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
status.register(
    "pulseaudio",
    on_leftclick="amixer -D pulse set Master toggle",
    # on_rightclick="pavucontrol",
    # bar_type='horizontal',
    color_muted='#EDBE9B',
    color_unmuted='#BD1D00',
    multi_colors=True,
    format="vol {volume_bar}",
    format_muted='vol [muted]',
)
# status.register(
#     "alsa",
#     on_leftclick="amixer -D pulse set Master toggle",
#     # on_rightclick="pavucontrol",
#     color=color03,
#     color_muted=color01,
#     format=" {volume_bar}",
#     format_muted=' [muted]',
# )
status.register("network",
    interface="wlp3s0",
    # format_up="{essid} {quality}%  {bytes_recv:3s} MB/s  {bytes_sent} MB/s",
    format_up="{essid}  {network_graph_recv}  {network_graph_sent}",
    dynamic_color=True,
    graph_style="braille-fill",
    separate_color=True,
    start_color=color14,
    end_color=color15,
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
    format='\u3000 {percentage:.0f}%[ ({remaining})]',
    not_present_text="",
    alert=True,
    alert_percentage=5,
    color=color05,
    interval=5,
)

# TEMPIRATURE ---------------------------------------------------------
status.register(
    "temp",
    format=" {temp}°",
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
    warn_color=color13,
    alert_color=color01,
    format=' {percent_used_mem}%',
)
# cpu frequency
status.register(
    "cpu_freq",
    format="{avgg} Ghz",
    color=color09,
)
# load
status.register(
    "load",
    format="\uf0e7\u3000 {avg1}",
    color=color10,
)

# CPU USAGE -----------------------------------------------------------
status.register(
    "cpu_usage",
    color=color11,
    on_leftclick=terminal + " -e 'htop'",
    format='  {usage:-4d}%',
)
# ping
status.register(
    "ping",
    format="\uF079\u3000 {ping} ms",
    format_down="unreachable",
    color=color12,
)

# weather  ------------------------------------------------------------
status.register(
    'weather',
    format='{current_temp}{temp_unit}[ {icon}][ {update_error}]',
    colorize=True,
    color_icons={
        'Fair': ('☼ معتدل', '#ffcc00'),
        'Cloudy': ('☁ غائم', '#f8f8ff'),
        'Partly Cloudy': ('☁ غائم جزئيا', '#844747'),
        'Fog': (' الضباب', '#949494'),
        'Sunny': ('☀ مشمس', '#ffff00'),
        'default': ('', None),
        'Rainy': ('⛈ ممطر', '#cbd2c0'),
        'Thunderstorm': ('⚡ عاصفة رعدية', '#cbd2c0'),
        'Snow': ('☃ ثلج', '#ffffff'),
    },
    hints={'markup': 'pango'},
    backend=weathercom.Weathercom(
        location_code='USMA0502:1:US',
        units='imperial',
    ),
)

status.run()
