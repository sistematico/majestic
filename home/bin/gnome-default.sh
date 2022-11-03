#!/usr/bin/env bash
#
# Arquivo: gnome-config.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <sistematico@gmail.com>
#
# Criado em: 03/11/2022 11:44:45
# Última alteração: 03/11/2022 11:44:51

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

# Logout delay
gsettings set org.gnome.SessionManager logout-prompt false

# Auto-Raise
# Default: false
# gsettings set org.gnome.desktop.wm.preferences auto-raise true

# Default: 'click' //  'mouse' or 'sloppy' 
gsettings set org.gnome.desktop.wm.preferences focus-mode 'mouse'

######################
# GNOME Software     #
######################
# Prevent GNOME Software from downloading updates
gsettings set org.gnome.software download-updates false

######################
# GEDIT              #
######################
# Remember last opened folder
# GTK 3
#gsettings set org.gtk.Settings.FileChooser startup-mode cwd

# GTK 2
#echo 'StartupMode=cwd' >> $HOME/.config/gtk-2.0/gtkfilechooser.ini

######################
# Evolution          #
######################
# Default: false
gsettings set org.gnome.evolution.mail composer-no-signature-delim true

######################
# Terminal           #
######################
# Disable confirmation on terminal close
gsettings set org.gnome.Terminal.Legacy.Settings confirm-close false

######################
# Theme              #
######################

# GTK 3-4
#gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"

# GTK 2
#mkdir ~/.themes && ln -s /usr/share/themes/Adwaita-dark ~/.themes/Adwaita

# Icon
# Default: 'Gnome'
gsettings set org.gnome.desktop.interface icon-theme 'Newaita'

# Shell
# Default: 'Adwaita'
# gsettings set org.gnome.shell.extensions.user-theme name "Flat-Remix"

######################
# Sound Theme        #
######################
# System Wide
#/usr/share/soundsor On User
#~/.local/share/sounds

# Default: 'freedesktop'
#gsettings set org.gnome.desktop.sound theme-name 'freedesktop'

# Default: true
#gsettings set org.gnome.desktop.sound event-sounds true

# Default: false
#gsettings set org.gnome.desktop.sound input-feedback-sounds true

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

######################
# RESET GNOME FONTS  #
######################
#gsettings reset org.gnome.desktop.interface font-name
#gsettings reset org.gnome.desktop.interface document-font-name
#gsettings reset org.gnome.desktop.interface monospace-font-name
#gsettings reset org.gnome.desktop.wm.preferences titlebar-font
#gsettings reset org.gnome.desktop.interface text-scaling-factor
#gsettings reset org.gnome.nautilus.desktop font
