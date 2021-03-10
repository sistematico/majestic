#!/usr/bin/env bash
#
# Arquivo: alarme.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 16-03-2018 16:35:20
# Última alteração: 13-01-2019 16:58:17

# Pacotes necessários: sound-theme-freedesktop & libcanberra

icone="${HOME}/.local/share/icons/elementary/preferences-system-network.png"
# /usr/share/sounds/freedesktop/stereo/
online="phone-incoming-call"
offline="phone-outgoing-busy"

host=${1:-"8.8.8.8"}			# Host
tentativas=1					# Tentativas por vez
intervalo=10					# Em segundos, entre tentativas
repeticao="sim"					# Loop infinito
processo="$(pgrep -f ping.sh)"

function pingar {
	ping -q -c $tentativas $host > /dev/null 2> /dev/null
	if [ $? -eq 0 ]; then
		# Polybar
		# if [ "$1" == "-v" ]; then
		# 	echo "%{F#8fbcbb}%{F-}"
		# fi
		if [ ! -f /tmp/online.lock ]; then
			export DISPLAY=:0 ; canberra-gtk-play -i $online 2>&1
			dbus-launch notify-send -i $icone "Ping" "A máquina <b>$(hostname)</b> está online."
			touch /tmp/online.lock
		else
			exit 0
		fi
		break
	else
		# Polybar
		# if [ "$1" == "-v" ]; then
		# 	echo "%{F#bf616a}%{F-}"
		# fi
		#export DISPLAY=:0 ; canberra-gtk-play -i $offline 2>&1
		icone="${HOME}/.local/share/icons/elementary/network-error.png"
		dbus-launch notify-send -i $icone "Ping" "A máquina <b>$(hostname)</b> está offline."
		[ -f /tmp/online.lock ] && rm /tmp/online.lock
	fi
}

if [[ $(pgrep -f ping.sh) == 0 ]]; then
 	dbus-launch notify-send -i $icone "Ping" "Processo parado."
 	kill -9 $(pgrep -fn "ping.sh") 1> /dev/null &
 	exit 1
else
	dbus-launch notify-send -i $icone "Ping" "Processo iniciado.\n\nHost: $host\nIntervalo: $intervalo\nTentativas: $tentativas\nRepetição: $repeticao"
fi

if [ "$repeticao" == "sim" ]; then
	while true; do
		pingar
		sleep $intervalo
	done
else
	pingar
fi

exit 0