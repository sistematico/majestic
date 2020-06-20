#!/usr/bin/env bash

killall -q polybar
polybar base &
polybar left &
polybar center &
polybar right &
