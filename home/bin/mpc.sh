#!/usr/bin/env bash

for app in yad mpc
do
    if ! command -v $app >/dev/null;
    then 
        echo "$app não instalado. Instale primeiro."
        exit
    fi
done

TITLE="MPC Playlist"
MPD_PATH="$HOME/.mpd/playlists"
musicas=($(ls $MPD_PATH))

for musica in "${musicas[@]}"
do
    nome=$(echo "$musica" | cut -f 1 -d '.')
    playlists="$playlists $nome"
done

rcmd=$(yad --window-icon="gtk-execute" --center --width 300    \
    --entry --title "$TITLE"                                    \
    --image=audio-headphones                                    \
    --button="Cancelar:1" --button="Carregar:0"                 \
    --text "Escolha uma Playlist"                               \
    --entry-text                                                \
    "Nova" $playlists)
  
[[ -z "$rcmd" ]] && exit 0
 
[[ "$rcmd" == "Nova" ]] && nova=$(yad --width=300 --center --window-icon="gtk-execute" --name="${0##*/}" --title="$TITLE" --text="Crie uma nova playlist" --image="gtk-execute" --entry --editable)

if [ "$nova" ]; then
    bash -c "mpc stop"
    bash -c "mpc clear"
    bash -c "mpc ls | mpc add"
    bash -c "mpc save $nova"
    bash -c "mpc load $nova"
    bash -c "mpc play"
else
    bash -c "mpc clear"
    bash -c "mpc load $rcmd"
    bash -c "mpc play"
fi
