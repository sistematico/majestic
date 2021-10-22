#!/usr/bin/env bash

killall -q polybar

polybar --config=$HOME/.config/polybar/config dracula >> /tmp/polybar.log 2>&1 & disown


