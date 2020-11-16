#!/usr/bin/env bash

dimensions=$(xdpyinfo  | awk '/dimensions:/ {print $2}')
dominant=$(convert $HOME/gitlab/lnxpcs/distro/arch/arch-linux-n1.png -scale 50x50! -depth 8 +dither -colors 8 -format "%c" histogram:info: | awk 'NR==1{print $3}')

function mkWall() {
	convert "$1" -gravity center -resize "${dimensions}" -background "$dominant" -extent "${dimensions}" "$2"
}

OIFS="$IFS"
IFS=$'\n'
#for file in `find . -type f -name "*.csv"`
#do
#     echo "file = $file"
#     diff "$file" "/some/other/path/$file"
#     read line
#done



if [ $1 ]; then
    imgs=( "$@" )
else
    imgs=($(ls -d $(pwd)/*.{jpg,jpeg,png} 2> /dev/null))
fi

[ -z "$imgs" ] && exit

for img in "${imgs[@]}"
do
    type="$(file -ib "$img" | awk -F'/' '{print $1}' 2> /dev/null)"
    if [ "$type" == "image" ]; then
        file -b "$img"
    fi
done

IFS="$OIFS"
