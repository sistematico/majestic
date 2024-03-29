#!/usr/bin/env bash
#
# Arquivo: viewnior.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 16/03/2018 16:35:20
# Última alteração: 29-11-2019 14:50:28

[ ! $1 ] && echo "Uso: $(basename $0) /caminho" && exit

dirs="$@"
for dir in "${dirs[@]}"
do
    if [ -d "$dir" ]; then
        cd "$dir"
        DISPLAY=:0 viewnior $(find . -type f \( -iname "*.png" -o -iname "*.svg" -o -iname "*.jpg" \))
    fi
done

exit
