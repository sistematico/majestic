#!/usr/bin/env bash

host="${1:-hera}"

mkdir /tmp/sites/ && 

rsync -avzz root@${host}:/etc/nginx/sites/ /tmp/sites/ --delete && 

cp -r /tmp/sites/ /tmp/sites-$(date +%s ) &&

gedit /tmp/sites/* &&

rsync -avzz /tmp/sites/ root@${host}:/etc/nginx/sites/ &&

ssh root@${host} "systemctl restart nginx" &&

exit