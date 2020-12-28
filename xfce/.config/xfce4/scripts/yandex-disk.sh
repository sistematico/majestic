#!/usr/bin/env bash

#icon="${HOME}/.local/share/icons/newaita/folder-yandex-disk.svg"
cmd=$(yandex-disk -c ~/.config/yandex-disk/cn.cfg status | awk -F'[()]' 'NR==1{print $2}')

if pgrep yandex-disk > /dev/null 2> /dev/null; then
	echo "Yandex: ${cmd}"
else 
    echo ""
fi
