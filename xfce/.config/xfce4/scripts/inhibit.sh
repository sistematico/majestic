#!/usr/bin/env bash

STATUS=$(pacmd list-sink-inputs | awk -F': ' '/state/{print $2}')

if [ "$STATUS" == "RUNNING" ]; then
	XDG_RUNTIME_DIR=/run/user/$(id -u) /usr/bin/xfce4-screensaver-command -p
	echo "<img>$HOME/.local/share/icons/elementary/user-available.svg</img>"
else
	echo "<img>$HOME/.local/share/icons/elementary/user-busy.svg</img>"
fi
