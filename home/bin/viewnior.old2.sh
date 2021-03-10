#!/usr/bin/env bash
#
# Arquivo: viewnior.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 16/03/2018 16:35:20
# Última alteração: 29-11-2019 14:50:28

walk_dir () {    
    shopt -s nullglob dotglob

    for pathname in "$1"/*; do
        if [ -d "$pathname" ]; then
            walk_dir "$pathname"
        else
            case "$pathname" in
                *.jpg|*.png)
                    #printf '%s\n' "$pathname"
                    #path="$( cd "$(dirname "${pathname}")" )"
                    p="$(dirname \'${pathname}\')"
                    b="$(basename -- \'${pathname}\')"
                    #arquivos="${arquivos} \"${path}/${pathname}\""
                    arquivos="${arquivos} ${d}${b}"
                    
            esac
        fi
    done
}

if [ $1 ]; then
    for dir in "$@"
    do
        walk_dir "$dir"
    done
else
    walk_dir .
fi

if [ -n "$arquivos" ]; then
    #DISPLAY=:0 viewnior $arquivos
    echo $arquivos
    #ristretto $arquivos
fi