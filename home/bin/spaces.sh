#!/usr/bin/env bash
#
# Sugestão de uso:
# 
# fdupes -fr -o time dir/ > /tmp/list.txt
# spaces.sh /tmp/list.txt file

[ $# -lt 1 ] && [ ! -z $1 ] && [ -f $1 ] && path="${1}" || exit 1
shift ; op="$@"

OIFS="$IFS"
IFS=$'\n'
for file in $(cat $path) # for file in $(find . -type f -name "*.csv")  
do
     echo "Executar: ${op} ${file}?" #rm -i "$file"
     read line
     [[ "$line" != [sSyY] ]] && exit
     ${op} "${file}"
done
IFS="$OIFS"