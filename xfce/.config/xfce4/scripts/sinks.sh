#!/bin/bash

sink=$(pactl list short sinks | awk 'NR==1{print $2}')
active=$(LANG=C pactl list sinks | awk '{if ($1 == "Active" && $2 == "Port:") {print $3; exit;}}')
icon="/usr/share/icons/Newaita-dark/devices/22/audio-headset.svg"

if [[ $active != *"headphones"* ]]; then
	icon="/usr/share/icons/Newaita-dark/.DP/22/speaker.svg"
fi

echo "<img>${icon}</img>"
echo "<click>bash -c $HOME/bin/select-sink.sh</click>"
