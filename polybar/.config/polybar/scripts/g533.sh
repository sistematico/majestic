#!/usr/bin/env bash
#
# ~/.config/polybar/scripts/g533.sh
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
		echo "%{F${cor}}%{F-} $videos / $imagens"
	elif [ $videos -gt 0 ] && [ $imagens -eq 0 ]; then
		echo "%{F${cor}}%{F-} $videos"
	elif [ $videos -eq 0 ] && [ $imagens -gt 0 ]; then
		echo "%{F${cor}}%{F-} $imagens"
	else
		echo "%{F${cor}}%{F-} 0"
	fi
fi





icon="${HOME}/.local/share/icons/panel/batt"

if ! sudo /usr/local/bin/headsetcontrol -b 2> /dev/null | grep -q Battery; then
	#echo "<img>${icon}/full.png</img>"
	[ $1 ] && echo "??%" || echo "<img>${icon}/audio-headset.png</img>"
	exit
fi

batt=$(sudo /usr/local/bin/headsetcontrol -b | grep Battery | awk '{print $2}')
batt=${batt%?}

if [ $1 ]; then
	if [ "$batt" == "Chargin" ]; then
		echo "Carr."
	elif [ "$batt" -gt 0 ]; then
		echo "${batt}%"
	fi
	exit
fi

if [ "$batt" == "Chargin" ]; then
	echo "<img>${icon}/charging.png</img>"
elif [ "$batt" -ge 90 ]; then
    echo "<img>${icon}/100.png</img>"
elif [ "$batt" -ge 75 ]; then
    echo "<img>${icon}/75.png</img>"
elif [ "$batt" -ge 50 ]; then
    echo "<img>${icon}/50.png</img>"
elif [ "$batt" -ge 10 ]; then
    echo "<img>${icon}/25.png</img>"
elif [ "$batt" -ge 5 ]; then
    echo "<img>${icon}/5.png</img>"
else
    echo "<img>${icon}/full.png</img>"
fi
