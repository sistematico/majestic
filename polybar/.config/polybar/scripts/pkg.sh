#!/bin/bash

pac=$(checkupdates 2> /dev/null | wc -l)
aur=$(yay -Qum 2> /dev/null | wc -l)
icone="${HOME}/.local/share/icons/elementary/package.svg"

if [ $1 ]; then
	if [ $pac -gt 0 ] || [ $aur -gt 0 ]; then
		$TERMINAL -e "yay -Syu"
	else
		notify-send -i $icone "Updates" "Nenhuma atualização disponível."
	fi
else
	echo "${pac}/${aur}"
fi