#!/bin/sh

cor=$(xrdb -query | grep border | head -n1 | awk '{print $2}')

if [ "$1" == "lock" ]; then
	$HOME/.local/lock/fortune &
else
	if pgrep -x "xautolock" > /dev/null
	then
		if [ $1 ]; then
			killall xautolock &
			notify-send -i "/usr/share/icons/Newaita-dark/apps/48/screensaver.svg" "Screen Locker" "Proteção de tela desativada."
		fi
		echo "%{F${cor}}%{F-}"
	else
		if [ $1 ]; then 
			xautolock -time 3 -detectsleep -locker $HOME/.local/lock/fortune &
			notify-send -i "${HOME}/.local/share/icons/Newaita-dark/apps/48/screensaver.svg" "Screen Locker" "Proteção de tela ativada."
		fi
		echo ""
	fi
fi
