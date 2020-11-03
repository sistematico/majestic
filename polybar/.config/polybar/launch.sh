#!/usr/bin/env bash

killall -q polybar
polybar top >>/tmp/polybar-top.log 2>&1 & disown
polybar bottom >>/tmp/polybar-bottom.log 2>&1 & disown



