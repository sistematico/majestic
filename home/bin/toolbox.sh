#!/usr/bin/env bash

processo="$(pgrep -f toolbox.sh)"

[ -n "$processo" ] && echo $$