#!//usr/bin/zsh

# echo -n ' ('
# ps aux | sort -rn +2 | head -2 | awk '{ print $3,$11}' | while read ll; do
#  echo -n "$ll  :: "
# done
# echo -n ') '
x=($(ps aux | sort -rn +2 | head -1 ))
y=$x[11]
echo "$x[3] ${y:t}"

