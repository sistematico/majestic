#!/usr/bin/env bash
#
# Polybar downloads.sh
#

cor=$(xrdb -query | grep foreground | head -n1 | awk '{print $2}')
icon=""

if [ "$1" == "c" ]; then
	killall youtube-dl
elif [ "$1" == "x" ]; then
	bash -c "$HOME/bin/videodown.sh"
elif [ "$1" == "a" ]; then
	bash -c "$HOME/bin/mp3down.sh"
elif [ "$1" == "i" ]; then
	bash -c "$HOME/bin/imgdown.sh"
elif [ "$1" == "d" ]; then
	bash -c "cat /dev/null > /var/tmp/videodown.hist"
else 
	videos=$(ps -A | grep youtube-dl | wc -l)
	imagens=$(ps -ef | grep imgdown.sh | grep -v grep | wc -l)

	if [ $videos -gt 7 ] || [ $imagens -gt 7 ]; then
		cor="#ff5555"
	elif [ $videos -gt 5 ] || [ $imagens -gt 5 ]; then
		cor="#f1fa8c"
	elif [ $videos -gt 3 ] || [ $imagens -gt 3 ]; then
		cor="#50fa7b"	
	elif [ $videos -gt 1 ] || [ $imagens -gt 1 ]; then
		cor="#8be9fd"		
	fi
	
	if [ $videos -gt 0 ] && [ $imagens -gt 0 ]; then
		echo "%{T3}${icon}%{T-} %{F${cor}}${videos}%{F-} / %{F${cor}}${imagens}%{F-}"
	elif [ $videos -gt 0 ] && [ $imagens -eq 0 ]; then
		echo "%{T3}${icon}%{T-} %{F${cor}}${videos}%{F-}"
	elif [ $videos -eq 0 ] && [ $imagens -gt 0 ]; then
		echo "%{T3}${icon}%{T-} %{F${cor}}${imagens}%{F-}"
	else
		#echo "%{T3}${icon}%{T-}"
		echo ""
	fi
fi