#!/usr/bin/env bash

BATT=$(sudo headsetcontrol -b | awk '/Battery/{print $2}')

if [ ! -z $BATT ]; then
	if [ "$BATT" == "Charging" ]; then
		echo "🎧️ Carregando"
	else
		echo "🎧️ ${BATT}"
	fi
else
	echo "🎧️"
fi
