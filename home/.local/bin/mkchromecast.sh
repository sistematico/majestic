#!/usr/bin/env bash

pgrep -x mkchromecast > /dev/null && sudo pkill -9 mkchromecast
#pgrep -x mpv >/dev/null && sudo pkill -9 mpv

sleep 1

arquivo=${1}
base=$(echo ${arquivo%.*})
legenda="${base}.srt"
params="--video -i"

[ -f "$legenda" ] && sub="--subtitle ${legenda}"
#[ -f "$arquivo" ] && mkchromecast $params "$arquivo" $sub > /dev/null 2> /dev/null &
[ -f "$arquivo" ] && python /usr/bin/mkchromecast "$params" \"${arquivo}\" \"${sub}\"
