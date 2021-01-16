#!/usr/bin/env bash
#
# ~/.config/polybar/scripts/g533.sh
#

cor=$(xrdb -query | grep border | head -n1 | awk '{print $2}')

if ! sudo /usr/local/bin/headsetcontrol -b 2> /dev/null | grep -q Battery; then
    echo ""
	exit
fi

batt=$(sudo /usr/local/bin/headsetcontrol -b | grep Battery | awk '{print $2}')
batt=${batt%?}

if [ "$batt" == "Chargin" ]; then
	echo "%{F${cor}}%{F-} Carr."
else
    echo "%{F${cor}}%{F-} ${batt}"
fi
