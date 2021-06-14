#!/usr/bin/env bash

[[ $EUID -eq 0 ]] && exit

######################
# BACKUP             #
######################
#dconf dump /org/gnome/ > backup.txt

######################
# RESET              #
######################
# dconf reset -f /org/gnome/

######################
# MATE               #
######################
# Center new windows
gsettings set org.gnome.mutter center-new-windows true

# Hide computer icon
gsettings set org.mate.caja.desktop computer-icon-visible false

# Numlock ON
#gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true

# Numlock Last State
gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true

# Three Buttons
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

# Logout delay
gsettings set org.gnome.SessionManager logout-prompt false

# Auto-Raise
# Default: false
gsettings set org.gnome.desktop.wm.preferences auto-raise true

# Default: 'click' //  'mouse' or 'sloppy' 
gsettings set org.gnome.desktop.wm.preferences focus-mode 'mouse'

######################
# Theme              #
######################

# GTK 3-4
# gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"

# GTK 2
#mkdir ~/.themes && ln -s /usr/share/themes/Adwaita-dark ~/.themes/Adwaita

# Icon
# Default: 'Gnome'
# gsettings set org.gnome.desktop.interface icon-theme 'Newaita'

# Shell
# Default: 'Adwaita'
# WRONG: gsettings set org.gnome.desktop.wm.preferences theme 'Adwaita'
# gsettings set org.gnome.shell.extensions.user-theme name "Flat-Remix"

######################
# Nautilus           #
######################
# Always show text-entry location
# Default: false
gsettings set org.gnome.nautilus.preferences always-use-location-entry true

######################
# GTK                #
######################
# Sort directories first
gsettings set org.gtk.Settings.FileChooser sort-directories-first true