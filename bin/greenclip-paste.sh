#!/bin/bash

# Capture the current clipboard

# BEFORE="$( xclip -o -selection clipboard )"

# ret=$(rofi -modi "clipboard:greenclip print" -show clipboard -run-command '{cmd}'  -kb-custom-1 Control+v -kb-custom-2 Control+c)

ret="$(greenclip print | rofi -dmenu -kb-custom-1 Control+v -kb-custom-2 Control+c)"


sleep 0.5

# Capture the selection
TEXT="$( xclip -o -selection clipboard )"

# Only attempt to paste if there has been selection
if [ "${TEXT}" != "${BEFORE}" ]; then
  xdotool type "$TEXT"
fi
