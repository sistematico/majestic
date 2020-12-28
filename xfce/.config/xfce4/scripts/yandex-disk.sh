#!/usr/bin/env bash

config="cn"
cmd=$(yandex-disk -c ~/.config/yandex-disk/${config}.cfg status | awk -F'[()]' 'NR==1{print $2}')

if pgrep yandex-disk > /dev/null 2> /dev/null; then
	echo "Yandex: ${cmd}"
else 
    echo ""
fi
