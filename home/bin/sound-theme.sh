#!/usr/bin/env bash
#################################################################################
#                                                                               #
# sound-theme.sh                                                                #
#                                                                               #
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br>          #
#                                                                               #
# Criado em: 07-07-2020 07:44:51                                                #
# Modificado em: 07-07-2020 07:44:58                                            #
#                                                                               #
# Este trabalho está licenciado com uma Licença Creative Commons                #
# Atribuição 4.0 Internacional                                                  #
# http://creativecommons.org/licenses/by/4.0/                                   #
#                                                                               #
#################################################################################

command -v dialog >/dev/null 2>&1 || { echo "Programa dialog não encontrado. Abortando..." ; exit 1; }

#xfconf-query -c xsettings -p /Net/EnableEventSounds -s true
#xfconf-query -c xsettings -p /Net/EnableInputFeedbackSounds -s true
#xfconf-query -c xsettings -p /Net/SoundThemeName -s "Borealis"

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

echo $tema