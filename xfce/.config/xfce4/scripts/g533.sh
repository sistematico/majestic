#!/usr/bin/env bash
################################################################################
#                                                                              #
# Arquivo: ~/.config/xfce4/scripts/g533.sh                                     #
#                                                                              #
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br>         #
#                                                                              #
# Criado em: 16/06/2021 09:04:44                                               #
# Modificado em: 09/08/2021 23:48:28                                           #
#                                                                              #
# Este trabalho está licenciado com uma Licença Creative Commons               #
# Atribuição 4.0 Internacional                                                 #
# http://creativecommons.org/licenses/by/4.0/                                  #
#                                                                              #
################################################################################

batt=$(sudo /usr/local/bin/headsetcontrol -b | grep Battery | awk '{print $2}')
batt=${batt%?}

if [ "$batt" == "Chargin" ]; then
	echo "<img>${HOME}/.local/share/icons/panel/batt/charging.svg</img>"
elif [ "$batt" -ge 90 ]; then
    echo "<img>${HOME}/.local/share/icons/panel/batt/100.svg</img>"
elif [ "$batt" -ge 75 ]; then
    echo "<img>${HOME}/.local/share/icons/panel/batt/75.svg</img>"
elif [ "$batt" -ge 50 ]; then
    echo "<img>${HOME}/.local/share/icons/panel/batt/50.svg</img>"
elif [ "$batt" -ge 10 ]; then
    echo "<img>${HOME}/.local/share/icons/panel/batt/25.svg</img>"
elif [ "$batt" -ge 5 ]; then
    echo "<img>${HOME}/.local/share/icons/panel/batt/5.svg</img>"
else
    echo "<img>${HOME}/.local/share/icons/panel/batt/full.svg</img>"
fi

[ ! -z "$batt" ] && echo "<txt>${batt}%</txt>" || echo "<txt>n/a</txt>"
[ ! -z "$batt" ] && echo "<tool>Restante: ${batt}%</tool>" || echo "<tool>Restante: ${batt}%</tool>"
