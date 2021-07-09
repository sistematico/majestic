#!/usr/bin/env bash

host="${1:-hera}"

editor="mousepad"
filemanager="thunar"

nginx_tmp="/tmp/nginx-sites"
snippets_tmp="/tmp/nginx-snippets"

[ ! -d $nginx_tmp ] && mkdir $nginx_tmp
[ ! -d $snippets_tmp ] && mkdir $snippets_tmp

rsync -avzz root@${host}:/etc/nginx/nginx.conf /tmp/nginx.conf --delete &&
rsync -avzz root@${host}:/etc/nginx/sites/ $nginx_tmp/ --delete &&
rsync -avzz root@${host}:/etc/nginx/snippets/ $snippets_tmp/ --delete &&

# Local Backup
cp -a /tmp/nginx.conf /tmp/nginx-$(date +%s).conf &&
cp -a $nginx_tmp $nginx_tmp-$(date +%s) &&
cp -a $snippets_tmp $snippets_tmp-$(date +%s) &&

# Remote Backup
ssh root@${host} "mkdir -p /var/backup/nginx/$(date +%Y)/$(date +%m)/$(date +%d)" &&
ssh root@${host} "cp /etc/nginx/nginx.conf /var/backup/nginx/$(date +%Y)/$(date +%m)/$(date +%d)/nginx-$(date +%s).conf" &&
ssh root@${host} "cp -a /etc/nginx/sites/ /var/backup/nginx/$(date +%Y)/$(date +%m)/$(date +%d)/sites-$(date +%s)" &&
ssh root@${host} "cp -a /etc/nginx/snippets/ /var/backup/nginx/$(date +%Y)/$(date +%m)/$(date +%d)/snippets-$(date +%s)" &&

$editor /tmp/nginx.conf $nginx_tmp/* && $filemanager $nginx_tmp $snippets_tmp &&

rsync -avzz $nginx_tmp/ root@${host}:/etc/nginx/sites/ --delete &&
rsync -avzz $snippets_tmp/ root@${host}:/etc/nginx/snippets/ --delete &&
rsync -avzz /tmp/nginx.conf root@${host}:/etc/nginx/nginx.conf --delete &&

ssh root@${host} "systemctl restart nginx" &&

exit
