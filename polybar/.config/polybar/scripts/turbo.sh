#!/usr/bin/env bash

killall dunst compton xautolock megasync
systemctl --user stop mpd x11vnc
sudo systemctl stop cronie docker snapd
