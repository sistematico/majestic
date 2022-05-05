#!/usr/bin/env bash
################################################################################
#                                                                              #
# Arquivo: ytmusic.sh                                                          #
# Descrição: Um script para baixar músicas do Youtube e Youtube Music          #
#                                                                              #
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br>         #
#                                                                              #
# Criado em: 30/04/2019 13:55:09                                               #
# Modificado em: 09/08/2021 23:34:37                                           #
#                                                                              #
# Este trabalho está licenciado com uma Licença Creative Commons               #
# Atribuição 4.0 Internacional                                                 #
# http://creativecommons.org/licenses/by/4.0/                                  #
#                                                                              #
################################################################################


[ $1 ] && url="$@" || url='https://music.youtube.com/playlist?list=PLp0YhNoP_vamRqnOAvQ-iqgMDJL19arSU'


yt-dlp -i -c \
    --cookies $HOME/.keys/cookies.txt \
    -f bestaudio \
    --extract-audio \
    --audio-format mp3 \
    --embed-thumbnail \
    --add-metadata \
    -o "%(artist)s - %(title)s.%(ext)s" \
    "$url"
