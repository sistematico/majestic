#!/usr/bin/env bash

[[ $EUID -eq 0 ]] && exit

######################
# GNOME              #
######################
# Center new windows
gsettings set org.gnome.mutter center-new-windows true

# Don't open folder on drag-n-drop
gsettings set org.gnome.nautilus.preferences open-folder-on-dnd-hover false

# Numlock ON
#gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true

# Numlock Last State
gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true

# Three Buttons
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

######################
# Evolution          #
######################
gsettings set org.gnome.evolution.mail composer-no-signature-delim true

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

######################
# GTK                #
######################
# Sort directories first
gsettings set org.gtk.Settings.FileChooser sort-directories-first true
