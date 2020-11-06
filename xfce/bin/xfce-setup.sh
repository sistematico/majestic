#!/usr/bin/env bash

[[ $EUID -eq 0 ]] && exit

######################
# XFCE              #
######################
# Disable Hibernate on LogOut Dialog
#xfconf-query -c xfce4-session -np '/shutdown/ShowHibernate' -t 'bool' -s 'false'

######################
# GTK                #
######################
# Sort directories first
gsettings set org.gtk.Settings.FileChooser sort-directories-first true

