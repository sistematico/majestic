#!/usr/bin/env bash
#
# Arquivo: move.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 13/09/2019 09:48:56
# Última alteração: 13/09/2019 09:49:00

# Debian
#app="id3"
# CentOS
app="id3v2"

caminho="/var/www/guerrilha.net/radio/uploads"
[ -f $caminho/yt.lck ] && exit

estilos=(principal rock punk)

#for arquivo in ${caminho}/*.mp3; do
for arquivo in $(find ${caminho} -maxdepth 2 -type f -iname "*.mp3"); do
        nome=$(basename -s .mp3 "$arquivo")
        artista=$(echo "$nome" | awk -F'-' '{print $1}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
        faixa=$(echo "$nome" | awk -F'-' '{$1=""; print}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

        if [ "$faixa" ]; then
                f=$(echo "$faixa" | sed -e 's/_/ /g')
                $app -t "$f" "$arquivo"
        fi

        if [ "$artista" ]; then
                a=$(echo "$artista" | sed -e 's/_/ /g')
                $app -a "$a" "$arquivo"
        fi
done

for estilo in "${estilos[@]}"
do
        [[ ! -d $caminho/$estilo ]] && mkdir -p $caminho/$estilo
        if ls $caminho/$estilo/* 2> /dev/null > /dev/null; then
        rsync --remove-source-files -avz $caminho/$estilo/ root@atlas:/opt/audio/$estilo/
        fi
done
