#!/usr/bin/env bash

icon="${HOME}/.local/share/icons/panel/batt"

yandex-disk -c ~/.config/yandex-disk/cn.cfg status | awk -F'[()]' 'NR==1{print $2}'
