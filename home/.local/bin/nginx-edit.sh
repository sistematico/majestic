#!/usr/bin/env bash

host="${1:-hera}"

editor="mousepad"
filemanager="thunar"

nginx_tmp="/tmp/nginx"
snippets_tmp="/tmp/snippets"

[ ! -d $nginx_tmp ] && mkdir $nginx_tmp
[ ! -d $snippets_tmp ] && mkdir $snippets_tmp

rsync -avzz root@${host}:/etc/nginx/sites/ $nginx_tmp/ --delete &&
rsync -avzz root@${host}:/etc/nginx/snippets/ $snippets_tmp/ --delete &&

cp -a $nginx_tmp $nginx_tmp-$(date +%s) &&
cp -a $snippets_tmp $snippets_tmp-$(date +%s) &&

$editor /etc/nginx/nginx.conf $nginx_tmp/* && $filemanager $nginx_tmp $snippets_tmp &&

rsync -avzz $nginx_tmp/ root@${host}:/etc/nginx/sites/ --delete &&
rsync -avzz $snippets_tmp/ root@${host}:/etc/nginx/snippets/ --delete &&

ssh root@${host} "systemctl restart nginx" &&

exit
