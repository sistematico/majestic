#!/usr/bin/env bash

[[ $EUID -eq 0 ]] && exit

######################
# GNOME              #
######################
# Numlock ON
#gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true

# Numlock Last State
gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true

# Three Buttons
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

# Center New Windows
gsettings set org.gnome.mutter center-new-windows true

######################
# Theme              #
######################

# GTK
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"

# Icon
# gsettings set org.gnome.desktop.interface icon-theme "Gnome"

# Shell
# gsettings set org.gnome.desktop.wm.preferences theme ""

######################
# Nautilus           #
######################
# Always show text-entry location
gsettings set org.gnome.nautilus.preferences always-use-location-entry true
