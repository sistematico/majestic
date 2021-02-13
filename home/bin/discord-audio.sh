#!/usr/bin/env bash

entrada='alsa_input.usb-Logitech_G533_Gaming_Headset-00.mono-fallback'
saida='alsa_output.usb-Logitech_G533_Gaming_Headset-00.analog-stereo'

pactl load-module module-null-sink sink_name=Virtual01
pacmd update-sink-proplist Virtual01 device.description=Virtual

pactl load-module module-loopback source=$entrada sink=Virtual01
pactl load-module module-loopback source=Virtual01.monitor sink=$saida
