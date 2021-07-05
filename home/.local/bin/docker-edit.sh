#!/usr/bin/env bash

editor="code"
filemanager="thunar"
confs="$HOME/docker/confs"

$editor $confs/nginx.conf && $filemanager $confs &&
docker restart nginx && exit
