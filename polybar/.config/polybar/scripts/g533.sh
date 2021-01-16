#!/usr/bin/env bash
#
# ~/.config/polybar/scripts/g533.sh
#

batt=$(sudo /usr/local/bin/headsetcontrol -b | grep Battery | awk '{print $2}')

#if ! sudo /usr/local/bin/headsetcontrol -b 2> /dev/null | grep -q Battery; then
#    echo ""
#	exit
#fi

if [ -z "$batt" ]; then
    echo "Not Found"
    exit
fi

cor=$(xrdb -query | grep border | head -n1 | awk '{print $2}')


if [ "$batt" == "Chargin" ]; then
	echo "%{F${cor}}%{F-} Carr."
else
    echo "%{F${cor}}%{F-} ${batt}"
fi
