#!/usr/bin/env bash

host="${1:-hera}"

[ -d /tmp/sites ] && rm -rf /tmp/sites
[ ! -d /tmp/sites ] && mkdir /tmp/sites

rsync -avzz root@${host}:/etc/nginx/sites/ /tmp/sites/ --delete && 
cp -r /tmp/sites/ /tmp/sites-$(date +%s ) &&
gedit /tmp/sites/* && nautilus /tmp/sites/ &&
rsync -avzz /tmp/sites/ root@${host}:/etc/nginx/sites/ --delete &&
ssh root@${host} "systemctl restart nginx" &&

exit
