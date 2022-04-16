#!/usr/bin/env bash

#--restrict-filenames \

[ $1 ] && url="$@" || url='https://music.youtube.com/playlist?list=PLp0YhNoP_vamRqnOAvQ-iqgMDJL19arSU'


yt-dlp -i -c \
    --cookies $HOME/.keys/cookies.txt \
    -f bestaudio \
    --extract-audio \
    --audio-format mp3 \
    --embed-thumbnail \
    --add-metadata \
    -o "%(artist)s - %(title)s.%(ext)s" \
    "$url"
