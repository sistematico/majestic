#!/bin/bash

profile="$(basename $(dirname $(find $HOME/.mozilla/firefox/ -iname storage.sqlite -print -quit)))"

[ ! -L $HOME/.mozilla/firefox/$profile/chrome ] && exit 1

temas=($HOME/github/majestic/firefox/*)
length=${#temas[@]}
length=$((length - 1))
current="$(basename $(readlink -f $HOME/.mozilla/firefox/$profile/chrome))"

for i in "${!temas[@]}"; do
    if [[ "${temas[$i]}" == *"$current"* ]]; then
        [ $i == $length ] && s=0 || s=$((i+1))
        rm -f $HOME/.mozilla/firefox/$profile/chrome
        ln -s ${temas[$s]} $HOME/.mozilla/firefox/$profile/chrome
        break
    fi
done
