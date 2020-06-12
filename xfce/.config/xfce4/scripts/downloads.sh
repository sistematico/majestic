#!/bin/bash

echo "$(ps -ef | grep youtube-dl | grep -v grep | wc -l)/$(ps -ef | grep 'bin/imgdown.sh' | grep -v grep | wc -l)"
