#!/usr/bin/env bash

if [ -d $HOME/.config/Code/User/snippets ]; then
	cd $HOME/.config/Code/User/snippets/
	for i in ls ../../../../Dropbox/vscode/AppData/Roaming/Code/User/snippets/*; do
		if [ -f "$i" ]; then
			ln -s "$i"
		fi
	done
fi
