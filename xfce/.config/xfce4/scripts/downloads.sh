#!/usr/bin/env bash
################################################################################
#                                                                              #
# Arquivo: ~/.config/xfce4/scripts/downloads.sh                                #
#                                                                              #
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br>         #
#                                                                              #
# Criado em: 09/08/2021 23:38:26                                               #
# Modificado em: 09/08/2021 23:38:31                                           #
#                                                                              #
# Este trabalho está licenciado com uma Licença Creative Commons               #
# Atribuição 4.0 Internacional                                                 #
# http://creativecommons.org/licenses/by/4.0/                                  #
#                                                                              #
################################################################################

inst="$(ps -ef | grep youtube-dl | grep -v grep | wc -l)"
echo "<img>/usr/share/icons/Newaita-dark/actions/24/go-down.svg</img>"
[ $inst -gt 0 ] && echo "<txt>$inst</txt> "
echo "<click>bash -c $HOME/bin/videodown.sh</click>"
echo "<tool>Video Down</tool>"