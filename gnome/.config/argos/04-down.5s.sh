#!/usr/bin/env bash

NUM=$(ps aux | grep yt-dlp | grep -v grep | wc -l)
DIR=$(dirname "$0")

if [ $NUM -gt 0 ]; then
	echo "🌍 ("${NUM}")️"
else
	echo "🌍️"
fi

echo "---"
echo "🎉️ Download | terminal=false bash='${HOME}/.dwm/scripts/vdown'"
echo "👾️ Video Down | bash='gedit ${HOME}/.dwm/scripts/vdown' terminal=false"
echo "✍️ Aria2 | bash='gedit $HOME/.aria2/aria2.conf' terminal=false"
#echo "❌ Apagar Histórico | bash='rm /var/tmp/videodown.hist' terminal=false"
