#!/usr/bin/env bash

editor="${VISUAL:-codium}"
filemanager="thunar"
confs="$HOME/docker/confs/nginx"

$editor $confs/nginx.conf && $filemanager $confs &&
docker restart nginx && exit
