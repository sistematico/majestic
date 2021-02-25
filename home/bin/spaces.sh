#!/usr/bin/env bash

[ ! -z $1 ] && [ -f $1 ] && path="${1}" || exit 1

OIFS="$IFS"
IFS=$'\n'
#for file in `find . -type f -name "*.csv"`  
for file in $(cat $path)  
do
     #echo "file = $file"
     #rm -i "$file"
     read line
done
IFS="$OIFS"