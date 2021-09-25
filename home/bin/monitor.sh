#!/usr/bin/env bash
#
# Arquivo: monitor.sh
#
# Mais um script feito com ❤️ por: 
# - "Lucas Saliés Brum" <lucas@archlinux.com.br>
# 
# Criado em: 23/09/2021 01:33:12
# Atualizado: 24/09/2021 12:50:50
#
# Referência:
# FG: reset = 0, black = 30, red = 31, green = 32, yellow = 33, blue = 34, magenta = 35, cyan = 36, white = 37
# BG: reset = 0, black = 40, red = 41, green = 42, yellow = 43, blue = 44, magenta = 45, cyan = 46, white=47

([ $1 ] && [ -d $1 ]) && dir=$1 || dir=$(pwd)

inotifywait -mr $dir -e create,moved_to,modify,delete |
    while read path action file; do
        case "$action" in
        *CREATE*)
            ACT="[\e[1;34mCRIADO\e[0m]"
        ;;
        *MODIFY*)
            ACT="[\e[1;33mMODIFICADO\e[0m]"
        ;;
        *DELETE*)
            ACT="[\e[1;31mAPAGADO\e[0m]"
        ;;
        *MOVED_TO*)
            ACT="[\e[1;37mMOVIDO\e[0m]"
        ;;
        *)
            ACT="[\e[1;31m${action}\e[0m]"
        ;;
        esac
        
        echo -e "${ACT} \e[1;37m${path}${file}\e[0m"
    done