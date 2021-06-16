#!/usr/bin/env bash
#
# Arquivo: g533.sh
# Descrição: 
#
# Feito por Lucas Saliés Brum, a.k.a. sistematico <lucas@archlinux.com.br>
#
# Criado em:        16/06/2021 09:04:44
# Última alteração: 16/06/2021 09:04:46

icon="${HOME}/.local/share/icons/panel/batt"

if ! sudo /usr/local/bin/headsetcontrol -b 2> /dev/null | grep -q Battery; then
	[ $1 ] && echo "" || echo "<img>${icon}/audio-headset.png</img>"
	exit
fi

batt=$(sudo /usr/local/bin/headsetcontrol -b | grep Battery | awk '{print $2}')
batt=${batt%?}

if [ $1 ]; then
	if [ "$batt" == "Chargin" ]; then
		echo "Carr."
	elif [ "$batt" -gt 0 ]; then
		echo "${batt}%"
	fi
	exit
fi

if [ "$batt" == "Chargin" ]; then
	echo "<img>${icon}/charging.png</img>"
elif [ "$batt" -ge 90 ]; then
    echo "<img>${icon}/100.png</img>"
elif [ "$batt" -ge 75 ]; then
    echo "<img>${icon}/75.png</img>"
elif [ "$batt" -ge 50 ]; then
    echo "<img>${icon}/50.png</img>"
elif [ "$batt" -ge 10 ]; then
    echo "<img>${icon}/25.png</img>"
elif [ "$batt" -ge 5 ]; then
    echo "<img>${icon}/5.png</img>"
else
    echo "<img>${icon}/full.png</img>"
fi
