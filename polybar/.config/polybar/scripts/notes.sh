#!/usr/bin/env bash

[ ! -f ${HOME}/.rofi_notes ] && touch ${HOME}/.rofi_notes

notes=$(cat ${HOME}/.rofi_notes | wc -l)
((notes--))

if [ $notes -gt 0 ]; then
	echo "%{F#D08770}%{F-} $notes"
else
	echo "%{F#D08770}%{F-}"
fi
