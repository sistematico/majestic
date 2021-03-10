#!/bin/sh

HOST=216.58.202.3

if ! ping=$(ping -n -c 1 -W 1 $HOST 2> /dev/null); then
    echo "%{F#BF616A}%{F-} ?"
else
    rtt=$(echo "$ping" | sed -rn 's/.*time=([0-9]{1,})\.?[0-9]{0,} ms.*/\1/p')

    if [ "$rtt" -lt 100 ]; then
        #icon="%{F#A3BE8C}%{F-}"
        icon="%{F#D08770}%{F-}"
    elif [ "$rtt" -lt 150 ]; then
        icon="%{F#A3BE8C}%{F-}"
    else
        icon="%{F#EBCB8B}%{F-}"
    fi

    echo "$icon $rtt ms"
fi