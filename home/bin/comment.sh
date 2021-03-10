#!/bin/bash

string="$1"

case $2 in
	comentar)
		sed -e "/$string/ s/^#*/#/" -i $3
		#sed -i "s/^#\($string\)\$/\1/" $3
    ;;
	descomentar)
		sed -e "/$string/ s/^#*//" -i $3
    	#sed -i "s/^$string\$/#&/" $3
    ;;
esac