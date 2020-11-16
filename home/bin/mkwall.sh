#!/usr/bin/env bash


# get gradient dimensions directly from the screenshot
#read width height <<<$(file $scr | cut -d, -f 2 | tr -d ' ' | tr 'x' ' ')
#height=$((height / 2))

width=$(identify -format %w $scr)
height=$(identify -format %h $scr)
dimensions=$(xdpyinfo  | awk '/dimensions:/ {print $2}')
dominant=$(convert $HOME/gitlab/lnxpcs/distro/arch/arch-linux-n1.png -scale 50x50! -depth 8 +dither -colors 8 -format "%c" histogram:info: | awk 'NR==1{print $3}')

convert "$scr" -scale 10% -scale 1000% -size "${width}x${height}" -gravity south-west	gradient:none-"$gradientcolor" -composite -matte "$icon" -gravity center -composite -matte -gravity center -size ${width}x30 -pointsize $fontsize	-font $font -fill "#EAE4D1" -annotate $textposition "$fortune" "$scr"
