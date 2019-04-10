#!/bin/bash 

# hostname() { echo "stinkbox2" }

hex="$(hostname | md5sum | cut -c1-2)"
dec="$(( 0x$hex  % 16 ))"

printf "colour${dec:-5}"




