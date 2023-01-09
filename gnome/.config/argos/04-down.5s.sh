#!/usr/bin/env bash

I=$(ps aux | grep yt-dlp | grep -v grep | wc -l)
Q=$(cat $HOME/.vdown/queue.txt | wc -l)
DIR=$(dirname "$0")

if [ $I -gt 0 ] || [ $Q -gt 0 ]; then
	echo "🌍 (i: "${I}" q: "${Q}")️"
else
	echo "🌍️"
fi

echo "---"
echo "🎉️ Download | terminal=false bash='${HOME}/.dwm/scripts/vdown'"
echo "👾️ Video Down | bash='code ${HOME}/.dwm/scripts/vdown' terminal=false"
echo "✍️ Aria2 | bash='gedit $HOME/.config/aria2/daemon.conf' terminal=false"
echo "❌ Matar Processos | bash='pkill yt-dlp && pkill aria2c' terminal=false"
echo "🧾️ Ver Logs | bash='nautilus ~/.vdown/logs/' terminal=false"
