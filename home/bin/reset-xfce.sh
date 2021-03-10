#!/usr/bin/env bash

[[ $EUID -eq 0 ]] && exit

TIMESTAMP=$(date +"%s")

xfce4-panel --quit
pkill xfconfd
mv ${HOME}/.config/xfce4 ~/.config/xfce4-$TIMESTAMP
mkdir -p ${HOME}/.config/xfce4
