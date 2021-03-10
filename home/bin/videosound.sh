#!/usr/bin/env bash
################################################################################
#                                                                              #
# videosound.sh                                                                #
#                                                                              #
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br>         #
#                                                                              #
# Criado em: 05-12-2019 3:11:07 am                                             #
# Modificado em: 05-12-2019 4:05:23 am                                         #
#                                                                              #
# Este trabalho está licenciado com uma Licença Creative Commons               #
# Atribuição 4.0 Internacional                                                 #
# http://creativecommons.org/licenses/by/4.0/                                  #
#                                                                              #
################################################################################

if [ $2 ]; then
    if [ "$(file -ibN ${1} | awk -F'/' '{print $1}')" != "video" ]; then
        echo "Formato de arquivo incorreto, o primeiro parâmetro precisa ser um arquivo de vídeo."
        exit 1
    fi

    if [ "$(file -ibN ${2} | awk -F'/' '{print $1}')" != "audio" ]; then
        echo "Formato de arquivo incorreto, o segundo parâmetro precisa ser um arquivo de audio."
        exit 1
    fi

    ffmpeg -i ${1} -i ${2} -c:v copy -map 0:v:0 -map 1:a:0 ${1%%.*}.new.${1#*.}
else
    echo "Uso: $(basename $0) video.mp3 audio.mp3"
fi

