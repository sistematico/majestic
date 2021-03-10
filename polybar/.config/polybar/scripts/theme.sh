#!/bin/bash

killall dunst
sleep .5

icone="${HOME}/.local/share/icons/elementary/multimedia-photo-viewer.svg"
cores=('#50fa7b' '#6272a4' '#ffb86c' '#ff79c6' '#ff5555' '#f1fa8c')
sel=${cores[$RANDOM % ${#cores[@]} ]}
sed -i "/! Border/{N; s/.*/! Border\n*border: $sel /}" $HOME/.Xresources
sed -i "/# Border/{N; s/.*/# Border\nframe_color = \"$sel\" /}" $HOME/.config/dunst/dunstrc
#sed -i "0,/frame_color =/{s/frame_color =.*/frame_color = \"${sel}\"/}" $HOME/.config/dunst/dunstrc
xrdb -merge $HOME/.Xresources
i3-msg restart
#killall dunst
dunst &
sleep .5
notify-send -i $icone "Tema" "Tema alterado para a cor: $sel"
