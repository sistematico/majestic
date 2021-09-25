#!/bin/bash

lockdir=/tmp/AXgqg0lsoeykp9L9NZjIuaqvu7ANILL4foeqzpJcTs3YkwtiJ0
if [ -d $lockdir ]; then
    echo "lock directory exists. exiting"
    exit 1
else
    mkdir $lockdir
fi
# take pains to remove lock directory when script terminates
#trap "rm -rf -- $lockdir" EXIT INT KILL TERM
trap "rm -rf -- $lockdir" EXIT

while [ : ]
do
    clear
    tput cup 5 5
    echo "$(date) [ press CTRL+C to stop ]"
    tput cup 6 5
    sleep 1
done