#!/usr/bin/env bash
################################################################################
#                                                                              #
# Arquivo: ~/bin/select-sink.sh                                                #
#                                                                              #
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br>         #
#                                                                              #
# Criado em: 30/04/2019 13:55:09                                               #
# Modificado em: 13/08/2021 14:57:29                                           #
#                                                                              #
# Este trabalho está licenciado com uma Licença Creative Commons               #
# Atribuição 4.0 Internacional                                                 #
# http://creativecommons.org/licenses/by/4.0/                                  #
#                                                                              #
################################################################################

sink=$(pactl list short sinks | awk 'NR==1{print $2}')
active=$(LANG=C pactl list sinks | awk '{if ($1 == "Active" && $2 == "Port:") {gsub(/[ \t]+$/, "", $2);print $3; exit;}}')

port_one=$(LANG=C pactl list sinks | awk '/Ports/{getline;gsub(":","");gsub(/[ \t]+$/, "", $2);print $1;}')
port_two=$(LANG=C pactl list sinks | awk '/Ports/{getline;getline;gsub(":","");gsub(/[ \t]+$/, "", $2);print $1;}')

if [[ $port_one == *"$active"* ]]; then
    pacmd set-sink-port $sink $port_two
    exit 0
fi

if [[ $port_two == *"$active"* ]]; then
    pacmd set-sink-port $sink $port_one
    exit 0
fi
