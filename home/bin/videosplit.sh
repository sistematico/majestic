#!/usr/bin/env bash

ffmpeg -i "$1" -vcodec copy -f segment -segment_time $2 "$1"%04d.mp4
