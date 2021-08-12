#!/bin/sh

cor=$(xrdb -query | grep foreground | head -n1 | awk '{print $2}')
icon="/usr/share/icons/Newaita-dark/apps/48/screensaver.svg"

# if [ ! $1 ] && grep -r RUNNING /proc/asound/card*/pcm*/sub*/status > /dev/null 2> /dev/null
# then
# 	echo ""
# 	exit
# fi

if [ "$1" == "lock" ]; then
	$HOME/.local/lock/fortune &
else
	if pgrep -x "xautolock" > /dev/null
	then
		if [ $1 ]; then
			killall xautolock &
			notify-send -i "$icon" "Screen Locker" "Proteção de tela desativada."
		fi
		echo "" #locked
	else
		if [ $1 ]; then 
			xautolock -time 3 -detectsleep -locker $HOME/.local/lock/fortune &
			notify-send -i "$icon" "Screen Locker" "Proteção de tela ativada."
		fi
		echo "" #unlocked
	fi
fi
