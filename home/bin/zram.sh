#!/usr/bin/env bash

[[ $EUID -ne 0 ]] && exit

if [ ! $1 ]; then
    echo "Usage: $(basename $0) [enable|disable]"
    exit
fi

if [ "$1" == "enable" ]; then
    modprobe zram
    echo lz4 > /sys/block/zram0/comp_algorithm
    echo 32G > /sys/block/zram0/disksize
    mkswap --label zram0 /dev/zram0
    swapon --priority 100 /dev/zram0
fi

if [ "$1" == "disable" ]; then
    swapoff /dev/zram0
    rmmod zram
fi
