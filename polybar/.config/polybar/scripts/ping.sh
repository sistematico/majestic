#!/usr/bin/env bash

# Pacotes necessários: sound-theme-freedesktop & libcanberra

# ls /usr/share/sounds/freedesktop/stereo/
online="phone-incoming-call"
offline="phone-outgoing-busy"
lock="$HOME/.ping.lock"

#h="127.0.0.1"
#h=${4:-"8.8.8.8"}
#r=${3:-1}

h="8.8.8.8"
r=1
v=1
l=0
c=0

function pingar {
	if ping -q -c${r} ${h} > /dev/null 2> /dev/null; then
		if [ $v == 1 ]; then
			if [ $c == 1 ]; then
				echo "%{F#8fbcbb}%{F-}"
			else
				echo ""
			fi
		fi

		if [ ! -f $lock ]; then
			export DISPLAY=:0 ; canberra-gtk-play -i $online 2>&1
			touch $lock
		fi
	else
		if [ $v == 1 ]; then
			if [ $c == 1 ]; then
				echo "%{F#bf616a}%{F-}"
			else
				echo ""
			fi
		fi

		if [ -f $lock ]; then
			rm -f $lock
		else
			export DISPLAY=:0 ; canberra-gtk-play -i $offline 2>&1
		fi

	fi
}

if [ $l = 1 ]; then
	while true; do
		pingar
		sleep 3
	done
else
	pingar
fi

# Never hurts...
exit 0
