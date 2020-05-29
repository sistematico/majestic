#!/usr/bin/env bash

term="urxvt"

read -r X Y W H < <(slop -f "%x %y %w %h" -b 1 -t 0 -q)
# Width and Height in px need to be converted to columns/rows
# To get these magic values, make a fullscreen st, and divide your screen width by ${tput cols}, height by ${tput lines} 
(( W /= 8 ))
(( H /= 16 ))
g=${W}x${H}+${X}+${Y}

bspc rule -a URxvt -o state=floating

#st -g $g
$term -g $g
