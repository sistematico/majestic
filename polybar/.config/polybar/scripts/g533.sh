#!/usr/bin/env bash
#
# ~/.config/polybar/scripts/g533.sh
#

cor=$(xrdb -query | grep foreground | head -n1 | awk '{print $2}')
batt=$(sudo /usr/local/bin/headsetcontrol -b 2> /dev/null | grep Battery | awk '{print $2}')

if [ -z "$batt" ]; then
    echo ""
    exit
fi

if [ "$batt" == "Charging" ]; then
	echo "%{F${cor}}%{F-} "
else
    echo "%{F${cor}}%{F-} ${batt}"
fi
