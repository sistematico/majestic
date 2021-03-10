#!/bin/bash

mapfile -t gov < <(cpupower frequency-info | grep 'reguladores do cpufreq disponíveis' | awk -F: '{print $2}' | awk '{$1=$1};1')

if [ ! $1 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo "Governadores disponíveis: ${gov[@]}"
	echo
	echo "Uso: $(basename $0) governador"
	echo
else
	if [[ " ${gov[*]} " == " $1 " ]]; then
    	echo "Setando o governador: $1 ..."
		sudo cpupower frequency-set -g $1
	fi
fi
