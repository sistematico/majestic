#!/usr/bin/env bash

killall -q polybar

polybar --config=$HOME/.config/polybar/config bar >> /tmp/polybar.log 2>&1 & disown

# Transparent
#polybar top >> /tmp/polybar-top.log 2>&1 & disown
#ln -s /tmp/polybar_mqueue.$! /tmp/ipc-top

#polybar bottom >> /tmp/polybar-bottom.log 2>&1 & disown
#ln -s /tmp/polybar_mqueue.$! /tmp/ipc-bottom

#echo hook:module/netx >>/tmp/polybar_mqueue.*


