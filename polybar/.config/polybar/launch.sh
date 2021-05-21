#!/usr/bin/env bash

killall -q polybar

# Dracula
polybar --config=$HOME/.config/polybar/dracula dracula >> /tmp/polybar-dracula.log 2>&1 & disown

# Transparent
#polybar top >> /tmp/polybar-top.log 2>&1 & disown
#ln -s /tmp/polybar_mqueue.$! /tmp/ipc-top

#polybar bottom >> /tmp/polybar-bottom.log 2>&1 & disown
#ln -s /tmp/polybar_mqueue.$! /tmp/ipc-bottom

#echo hook:module/netx >>/tmp/polybar_mqueue.*


