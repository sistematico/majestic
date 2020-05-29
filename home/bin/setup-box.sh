#!/usr/bin/env bash

dropbox="${HOME}/Dropbox/vscode/AppData/Roaming/Code/User/snippets"
vscode="${HOME}/.config/Code/User/snippets"
[ ! -d $vscode ] && mkdir -p $vscode

files=(
    'bulma.code-snippets'
    'git-rebase.json'
    'htmlredirect.code-snippets'
    'jsredirect.code-snippets'
    'snpt.code-snippets'
    'css.json'
    'htmlskel.code-snippets'
    'nginxredirect.code-snippets'
    'favicon.code-snippets'
    'html.json'
    'javascript.json'
    'php.json'
    'undefined.json'
)

for file in ${files[@]}; do
    if [ -f $dropbox/$file ]; then
		echo $file encontrado
        ln -s $dropbox/$file $vscode/$file
    fi
done
