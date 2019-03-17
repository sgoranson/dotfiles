#!/bin/bash

# echo -n ' ('
# ps aux | sort -rn +2 | head -2 | awk '{ print $3,$11}' | while read ll; do
#  echo -n "$ll  :: "
# done
# echo -n ') '
ps aux | sort -rn +2 | head -1 | awk '{ print $3,$11}' 
