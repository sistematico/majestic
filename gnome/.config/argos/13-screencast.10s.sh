#!/usr/bin/env bash

if pgrep -x "ffmpeg" > /dev/null && test -f "/tmp/screencast.pid"; then
	echo "📹️ (Gravando)️"
elif pgrep -x "ffmpeg" > /dev/null && test ! -f "/tmp/screencast.pid"; then
	echo "📹️ (Convertendo)️"
else
	echo "📹️"
fi

echo "---"
echo "🎉️ Iniciar/Parar | terminal=false bash='${HOME}/.local/bin/screencast'"
