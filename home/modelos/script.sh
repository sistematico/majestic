#!/usr/bin/env bash
#
# Arquivo: script.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 18/09/2021 15:48:06
# Última alteração: 18/09/2021 15:48:53

# Zenity Examples
szAnswer=$(zenity --entry --text "where are you?" --entry-text "at home"); echo $szAnswer
zenity --error --text "Installation failed! "
zenity --info --text "Join us at irc.freenode.net #lbe."

# For Examples
array=( "um" "dois" "tres" )

for arr in ${array[@]} 
do
    echo $arr
done

