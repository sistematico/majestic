#!/usr/bin/env bash

gtk3="$HOME/.config/gtk-3.0/settings.ini"
gtk2="$HOME/.gtkrc-2.0"

toggle() {
    if [ -f $1 ]; then
		pattern="$2"
		value="$3"
        if grep -q "$pattern" "$1"; then
			sed -i "s|${pattern}=.*|${pattern}=$value|g" $1
        fi
    fi
}

if [ $3 ]; then
	toggle $1 $2 $3
fi
