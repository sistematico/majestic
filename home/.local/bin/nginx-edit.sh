#!/usr/bin/env bash

host="${1:-hera}"

[ -d /tmp/sites ] && rm -rf /tmp/sites
[ ! -d /tmp/sites ] && mkdir /tmp/sites
[ ! -d /tmp/nginx-snippets ] && mkdir /tmp/nginx-snippets

rsync -avzz root@${host}:/etc/nginx/sites/ /tmp/sites/ --delete &&
rsync -avzz root@${host}:/etc/nginx/snippets/ /tmp/nginx-snippets/ --delete &&
cp -r /tmp/sites/ /tmp/sites-$(date +%s ) &&
cp -r /tmp/nginx-snippets/ /tmp/nginx-snippets-$(date +%s ) &&
gedit /tmp/sites/* && nautilus /tmp/sites/ /tmp/nginx-snippets/ &&
rsync -avzz /tmp/sites/ root@${host}:/etc/nginx/sites/ --delete &&
rsync -avzz /tmp/nginx-snippets/ root@${host}:/etc/nginx/snippets/ --delete &&
ssh root@${host} "systemctl restart nginx" &&

exit
