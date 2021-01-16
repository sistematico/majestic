#!/usr/bin/env bash
#
# ~/.config/polybar/scripts/g533.sh
#

batt=$(sudo /usr/local/bin/headsetcontrol -b | grep Battery | awk '{print $2}')

if [ -z "$batt" ]; then
    echo ""
    exit
fi

cor=$(xrdb -query | grep border | head -n1 | awk '{print $2}')

if [ "$batt" == "Charging" ]; then
	echo "%{F${cor}}%{F-} Carregando..."
else
    echo "%{F${cor}}%{F-} ${batt}"
fi
