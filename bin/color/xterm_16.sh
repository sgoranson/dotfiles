#!/bin/bash

echo

LB=("Black"	"Red"	"Green"	"Yellow"	"Blue"	"Magenta"	"Cyan"	"White")
echo

i=0
ci=0

for clbg in {40..47} {100..107} 49 ; do
		#Formatting

	  (( ci = i % 8 ))
	  tm=$(printf "%b%15b%b" "\e[${clbg};39m" "^[${clbg};39m" "\e[0m ")
	  tm_l=${#tm}
		printf "%-10s%s%10s" "$i" "$tm" "${LB[$ci]}"
		(( i++ ))
		echo
done

exit 0

# vim:ff=unix:  :
