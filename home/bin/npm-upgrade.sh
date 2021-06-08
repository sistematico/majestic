#!/bin/sh

EDGE=0

set -e
set -x

if [ $EDGE == 1 ]; then
    for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f3)
    do
        npm -g install "$package"
    done
else
    for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2)
    do
        npm -g install "$package"
    done
fi
