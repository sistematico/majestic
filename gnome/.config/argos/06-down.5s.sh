#!/usr/bin/env bash

NUM=$(ps aux | grep youtube-dl | grep -v grep | wc -l)
DIR=$(dirname "$0")

if [ $NUM -gt 0 ]; then
	echo "🌍 ("${NUM}")️"
else
	echo "🌍️"
fi

echo "---"
echo "🎉️ Download | terminal=false bash='${HOME}/bin/videodown.sh'"
echo "👾️ Video Down | bash='gedit $HOME/bin/videodown.sh' terminal=false"
echo "✍️ Aria2 | bash='gedit $HOME/.aria2/aria2.conf' terminal=false"
