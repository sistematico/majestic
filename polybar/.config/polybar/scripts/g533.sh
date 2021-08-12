#!/usr/bin/env bash
#
# ~/.config/polybar/scripts/g533.sh

if [ $1 ]; then
    $HOME/bin/select-sink.sh
fi

sink=$(pactl list short sinks | awk 'NR==1{print $2}')
active=$(LANG=C pactl list sinks | awk '{if ($1 == "Active" && $2 == "Port:") {print $3; exit;}}')
cor=$(xrdb -query | grep foreground | head -n1 | awk '{print $2}')

if [[ $active == *"analog-output"* ]]; then
    echo ""
    exit
fi

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


