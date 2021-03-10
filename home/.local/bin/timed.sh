#!/usr/bin/env bash
#
# Cron: 1 * * * * /home/usuario/.local/bin/timed 2>&1

dir="$HOME/img/heic/Atacama"
lock="$HOME/.timed.lock"
monitor="monitor$(xrandr | grep -m1 ' connected' | awk '{print $1}')" # monitor0

setWallpaper() {
	atual="$(cat $lock | tr -d '\040\011\012\015')"
	novo=$(ls -1 $dir/*${1}* | tail -n1 | tr -d '\040\011\012\015' 2> /dev/null)

	if [ -f "$novo" ] && [ "$novo" != "$atual" ]; then 
		echo "$novo" > $lock
		if [ "$XDG_CURRENT_DESKTOP" == "XFCE" ]; then
			env DBUS_SESSION_BUS_ADDRESS='unix:path=/run/user/1000/bus' $(which xfconf-query) -c xfce4-desktop -p /backdrop/screen0/monitor$(xrandr | grep -m1 ' connected' | awk '{print $1}')/workspace0/last-image -s "$novo"
		elif [ "$XDG_CURRENT_DESKTOP" == "i3" ]; then
			DISPLAY=:0 feh --bg-fill "$novo"
		fi
	fi
}

if [ $(date +%H) -gt 5 ] && [ $(date +%H) -lt 10 ]; then
	periodo='manha'
elif [ $(date +%H) -gt 9 ] && [ $(date +%H) -lt 15 ]; then
	periodo='almoco'
elif [ $(date +%H) -gt 14 ] && [ $(date +%H) -lt 19 ]; then
	periodo='tarde'
elif [ $(date +%H) -gt 18 ] && [ $(date +%H) -lt 6 ]; then
	periodo='noite'
fi

setWallpaper $periodo