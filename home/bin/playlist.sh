#!/usr/bin/env bash

[ $1 ] && path="$(realpath ${1})" || path="$(pwd)"

:> /tmp/playlist.m3u

OIFS="$IFS"
IFS=$'\n'
#for file in $(find $path -type f -name "*.mp4" | sort)
for file in $(find $path -type f \( -iname "*.mp4" -o -iname "*.webm" \) | sort)
do
     echo "file://${file}" >> /tmp/playlist.m3u
done
IFS="$OIFS"

mpv --loop-playlist=inf /tmp/playlist.m3u
