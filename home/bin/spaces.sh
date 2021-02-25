#!/usr/bin/env bash

OIFS="$IFS"
IFS=$'\n'
#for file in `find . -type f -name "*.csv"`  
for file in $(cat /tmp/dupes.txt)  
do
     #echo "file = $file"
     rm -i "$file"
     read line
done
IFS="$OIFS"