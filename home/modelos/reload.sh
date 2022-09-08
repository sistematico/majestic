#!/usr/bin/env sh

csum=""
new_csum=$(sha1sum reload.py)
while true
do
    if [ "$csum" != "$new_csum" ]
    then
        csum=$new_csum
        python reload.py
    else
        exit 0
    fi
    new_csum=$(sha1sum reload.py)
    sleep 0.5
done