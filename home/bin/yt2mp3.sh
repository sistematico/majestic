#!/usr/bin/env bash
#################################################################################
#                                                                               #
# yt2mp3.sh                                                                     #
#                                                                               #
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br>          #
#                                                                               #
# Criado em: 07-07-2020 07:21:15                                                #
# Modificado em: 07-07-2020 07:29:23                                            #
#                                                                               #
# Este trabalho está licenciado com uma Licença Creative Commons                #
# Atribuição 4.0 Internacional                                                  #
# http://creativecommons.org/licenses/by/4.0/                                   #
#                                                                               #
#################################################################################

[ -f $HOME/.config/user-dirs.dirs ] && source $HOME/.config/user-dirs.dirs

NOME="MP3 Down"
DIR="${HOME:-${XDG_MUSIC_DIR}}"
ICONE="${HOME}/.local/share/icons/elementary/video-display.png"

if [ ! -d "$DIR" ]; then
    DIR="${HOME}/desk"
    [ ! -d $DIR ] && mkdir -p $DIR
fi

[ $1 ] && url="$1" || url="$(xclip -o)"
cd $DIR

padrao='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [[ ! ${url} =~ $padrao ]]; then
    notify-send -i $ICONE "$NOME" "O link é inválido!"
    exit
else
    titulo="$(youtube-dl -s -f mp4 -o '%(id)s.%(ext)s' --print-json --no-warnings ${url} | jq -r '.title')"

    if [ ${#titulo} -gt 250 ]; then
        diff=$((${#titulo}-250))
        trim=$((${#titulo}-$diff))
        titulo=${titulo::-$trim}
    fi
fi

notify-send -i $ICONE "$NOME" "Transferencia de: \n\n<b>$titulo</b> iniciada."
youtube-dl --extract-audio --audio-format mp3 -o "${titulo}.%(ext)s" "${url}"







