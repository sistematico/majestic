#!/usr/bin/env bash
#
# Polybar downloads.sh
#

cor=$(xrdb -query | grep border | head -n1 | awk '{print $2}')

if [ "$1" == "c" ]; then
	killall youtube-dl
elif [ "$1" == "x" ]; then
	bash -c "$HOME/bin/videodown.sh"
elif [ "$1" == "i" ]; then
	bash -c "$HOME/bin/imgdown.sh"
else 
	videos=$(ps -A | grep youtube-dl | wc -l)
	imagens=$(ps -ef | grep imgdown.sh | grep -v grep | wc -l)
	
	if [ $videos -gt 0 ] && [ $imagens -gt 0 ]; then
		echo "%{F${cor}}%{F-} $videos / $imagens"
	elif [ $videos -gt 0 ] && [ $imagens -eq 0 ]; then
		echo "%{F${cor}}%{F-} $videos"
	elif [ $videos -eq 0 ] && [ $imagens -gt 0 ]; then
		echo "%{F${cor}}%{F-} $imagens"
	else
		echo "%{F${cor}}%{F-}"
	fi
fi