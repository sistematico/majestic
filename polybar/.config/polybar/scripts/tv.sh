#!/bin/sh

cor=$(xrdb -query | grep border | head -n1 | awk '{print $2}')

if pgrep -x "xautolock" > /dev/null
then
	if [ $1 ]; then
		killall xautolock &
		notify-send -i ~/.local/share/icons/elementary/screensaver.png "Screen Locker" "Proteção de tela desativada."
	fi
	echo "%{F${cor}}%{F-}"
else
	if [ $1 ]; then 
		xautolock -time 3 -detectsleep -locker $HOME/.local/lock/fortune &
		notify-send -i ~/.local/share/icons/elementary/screensaver.png "Screen Locker" "Proteção de tela ativada."
	fi
	echo ""
fi
