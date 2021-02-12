#!/usr/bin/env bash
dbus-send --session --type=method_call --dest=org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Eval string:'Main.overview._dash.actor.hide();'
