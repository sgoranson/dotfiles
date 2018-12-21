#!/bin/bash

# tput_colors - Demonstrate color combinations.

clear

echo "tput character test"
echo "==================="
echo

tput bold;  echo "This text has the bold attribute.";     tput sgr0

tput smul;  echo "This text is underlined (smul).";       tput rmul

# Most terminal emulators do not support blinking text (though xterm
# does) because blinking text is considered to be in bad taste ;-)
tput blink; echo "This text is blinking (blink).";        tput sgr0

tput rev;   echo "This text has the reverse attribute";   tput sgr0

# Standout mode is reverse on many terminals, bold on others.
tput smso;  echo "This text is in standout mode (smso)."; tput rmso

tput sgr0
echo

for fg_color in {0..16}; do
    set_foreground=$(tput setaf $fg_color)
    for bg_color in {0..16}; do
        set_background=$(tput setab $bg_color)
        echo -n $set_background$set_foreground
        printf ' F:%2s B:%2s ' $fg_color $bg_color

        if [[ $bg_color -gt 0 ]] && [[ $(( $bg_color % 8 )) -eq 0 ]]; then
            echo $(tput sgr0)
        fi
    done
done

echo
echo $(tput sgr0)

# vim:ff=unix:
