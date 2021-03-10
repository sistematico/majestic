#!/usr/bin/env bash

if [ ! -d ~/.config/xfce4.bkp ]; then
	mv ~/.config/xfce4 ~/.config/xfce4.bkp
	cp -r /etc/xdg/xfce4 ~/.config/
fi
