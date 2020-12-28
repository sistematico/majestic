#!/usr/bin/env bash

icon="${HOME}/.local/share/icons/newaita/folder-yandex-disk.svg"
cmd=$(yandex-disk -c ~/.config/yandex-disk/cn.cfg status | awk -F'[()]' 'NR==1{print $2}')

#echo "<img>${icon}</img> ${cmd}"
echo "Yandex: ${cmd}"
