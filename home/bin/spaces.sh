#!/usr/bin/env bash

[ $# -gt 0 ] && [ ! -z $1 ] && [ -f $1 ] && path="${1}" || exit 1
shift ; op="$@"

OIFS="$IFS"
IFS=$'\n'
for file in $(cat $path) # for file in $(find . -type f -name "*.csv")  
do
     echo "Executar: ${op} ${file}?" #rm -i "$file"
     read line
done
IFS="$OIFS"