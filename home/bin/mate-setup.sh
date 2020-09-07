#!/bin/bash

# Hide Icons
gsettings set org.mate.caja.desktop computer-icon-visible false
gsettings set org.mate.caja.desktop home-icon-visible false
gsettings set org.mate.caja.desktop network-icon-visible false
gsettings set org.mate.caja.desktop trash-icon-visible false
gsettings set org.mate.caja.desktop volumes-visible false

# Mate Menu Icon
theme=$(gsettings get org.mate.interface icon-theme)
theme="${theme%\'}"
theme="${theme#\'}"
path=$HOME/.local/share/icons/$theme/24x24/places/
[ ! -d $path ] && mkdir -p $path
[ ! -f ${path}/start-here.png ] && curl -L -s -o ${path}/start-here.png 'https://i.imgur.com/yV1xT3X.png'
gsettings set org.mate.panel.menubar icon-name 'start-here'


