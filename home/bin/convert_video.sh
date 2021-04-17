#!/usr/bin/env bash

file="$1"

echo $(file --mime-type -b "$file")

#if [ $(file --mime-type -b "$file") == '' ]; then
#ffmpeg -i "$file" "${file%.*}.mp4"
#fi