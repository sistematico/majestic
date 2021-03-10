#!/usr/bin/env bash
################################################################################
#                                                                              #
# viewnior.sh                                                                  #
#                                                                              #
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br>         #
#                                                                              #
# Criado em: 16-03-2018 16:35:20 pm                                             #
# Modificado em: 05-12-2019 12:31:19 am                                        #
#                                                                              #
# Este trabalho está licenciado com uma Licença Creative Commons               #
# Atribuição 4.0 Internacional                                                 #
# http://creativecommons.org/licenses/by/4.0/                                  #
#                                                                              #
################################################################################

shopt -s globstar dotglob nocaseglob

if [ $1 ]; then
	cd "$1"
    if [ $2 ]; then
        #DISPLAY=:0 viewnior "${1}/**/*${2}*.{jpg,png,svg}"
        #viewnior "${1}/**/*${2}*.{jpg,png,svg}"
        viewnior "**/*${2}*.{jpg,png,svg}"
    else
        #DISPLAY=:0 viewnior "${1}/**/*.{jpg,png,svg}"
        #viewnior "${1}/**/*.{jpg,png,svg}"
        viewnior "**/*.{jpg,png,svg}"
        #echo $1/**/*.{jpg,png,svg}
    fi
else
    #DISPLAY=:0 viewnior **/*.{jpg,png,svg}
    viewnior **/*.{jpg,png,svg}
fi

exit
