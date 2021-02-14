#!/usr/bin/bash env

ffmpeg -f pulse -i alsa_output.pci-0000_00_1b.0.analog-stereo.monitor -f pulse -i alsa_input.pci-0000_00_1b.0.analog-stereo -acodec libmp3lame -map 0:0 -map 1:0 outfile.mkv
