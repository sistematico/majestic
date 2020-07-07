#!/usr/bin/env bash
#################################################################################
#                                                                               #
# sound-theme.sh                                                                #
#                                                                               #
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br>          #
#                                                                               #
# Criado em: 07-07-2020 07:44:51                                                #
# Modificado em: 07-07-2020 08:13:02                                            #
#                                                                               #
# Este trabalho está licenciado com uma Licença Creative Commons                #
# Atribuição 4.0 Internacional                                                  #
# http://creativecommons.org/licenses/by/4.0/                                   #
#                                                                               #
#################################################################################

command -v dialog >/dev/null 2>&1 || { echo "Programa dialog não encontrado. Abortando..." ; exit 1; }
pacman -Qq libcanberra 1> /dev/null 2> /dev/null || { echo "Pacote libcanberra não encontrado. Abortando..." ; exit 1; }
pacman -Qq libcanberra-pulse 1> /dev/null 2> /dev/null || { echo "Pacote libcanberra-pulse não encontrado. Abortando..." ; exit 1; }

old=$(pwd)
cd /usr/share/sounds

i=1
for t in *; do
    if [ "$t" != "alsa" ]; then
        options="${options} ${i} ${t}"
        i=$((i+1))
    fi
done
options="${options} $i nenhum"

tema=$(dialog --stdout --title 'Tema' --menu 'Escolha um tema' 0 0 0 $options 2>&1)

if [ "$tema" == "nenhum" ]; then
    xfconf-query -c xsettings -p /Net/EnableEventSounds -s false
    xfconf-query -c xsettings -p /Net/EnableInputFeedbackSounds -s false
else
    xfconf-query -c xsettings -p /Net/EnableEventSounds -s true
    xfconf-query -c xsettings -p /Net/EnableInputFeedbackSounds -s true
    xfconf-query -c xsettings -p /Net/SoundThemeName -s "$tema"
fi

cd "$old"

exit 0