#!/usr/bin/env bash

width=$(xdpyinfo | grep dimensions | awk '{print $2}' | awk -Fx '{print $1}')
height=$(xdpyinfo | grep dimensions | awk '{print $2}' | awk -Fx '{print $2}')

function mkWall() {
    imgWidth=$(identify -format "%w" "$1") ; imgHeight=$(identify -format "%h" "$1")
    dominant=$(convert "${1}" -scale 50x50! -depth 8 +dither -colors 8 -format "%c" histogram:info: | awk 'NR==1{print $3}')
    nome="${1%.*}" ; ext="${1##*.}" ; arquivo="${nome}-${width}x${height}.${ext}"
    if [ ! -f "$arquivo" ]; then
        cp "$1" "$arquivo"
        if [ $imgWidth -gt $width ] || [ $imgHeight -gt $height ]; then
            mogrify -resize 90% "$arquivo"
        fi
        convert "$arquivo" -gravity center -resize "${width}x${height}>" -background "$dominant" -extent "${width}x${height}" "${arquivo}"
    fi
}

OIFS="$IFS"
IFS=$'\n'
if [ $1 ]; then
    imgs=("$@")
else
    imgs=($(ls -d $(pwd)/*.{jpg,jpeg,png} 2> /dev/null))
fi

[ -z "$imgs" ] && exit

for img in "${imgs[@]}"; do
    type="$(file -ib "$img" | awk -F'/' '{print $1}' 2> /dev/null)"
    if [ "$type" == "image" ]; then
        mkWall "$img"
    fi
done
IFS="$OIFS"
