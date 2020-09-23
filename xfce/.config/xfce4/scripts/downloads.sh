#!/bin/bash
#echo "$(ps -ef | grep youtube-dl | grep -v grep | wc -l)/$(ps -ef | grep 'bin/imgdown.sh' | grep -v grep | wc -l)"

inst="$(ps -ef | grep youtube-dl | grep -v grep | wc -l)"
if [ $inst -gt 0 ]; then
	echo $inst
else
	echo ""
fi
