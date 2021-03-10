#!/usr/bin/env bash

[ "$EUID" -ne 0 ] && echo "É necessário rodar o script como root." && exit 1

[ ! -d /etc/hosts.d/backup ] && mkdir -p /etc/hosts.d/backup
[ ! -f /etc/hosts.d/01-default.conf ] && cp /etc/hosts /etc/hosts.d/01-default.conf

ls -t /etc/hosts.d/backup/*.bkp.* 2> /dev/null | sed -e '1,10d' | xargs -d '\n' rm 2> /dev/null

url="https://hblock.molinero.dev/hosts"
curl -s -L "$url" > /etc/hosts.d/hblock.tmp
sed -i '0,/^# <\/header>$/d' /etc/hosts.d/hblock.tmp
sed -i '/analytics.google.com/d' /etc/hosts.d/hblock.tmp
sed -i '/googletagmanager.com/d' /etc/hosts.d/hblock.tmp

if [ -f /etc/hosts.d/02-hblock.conf ] && [ -f /etc/hosts.d/hblock.md5 ]; then
	if md5sum -c /etc/hosts.d/hblock.md5 > /dev/null; then
		rm /etc/hosts.d/hblock.tmp
	else
    	mv /etc/hosts.d/hblock.tmp /etc/hosts.d/02-hblock.conf
    	[ -f /etc/hosts ] && mv /etc/hosts /etc/hosts.d/backup/hosts.bkp.$(date +'%s')
    	cat /etc/hosts.d/*.conf > /etc/hosts
		md5sum /etc/hosts.d/02-hblock.conf > /etc/hosts.d/hblock.md5
	fi
else
	mv hblock.tmp 02-hblock.conf
	[ -f /etc/hosts ] && mv /etc/hosts /etc/hosts.d/backup/hosts.bkp.$(date +'%s')
	cat /etc/hosts.d/*.conf > /etc/hosts
    md5sum /etc/hosts.d/02-hblock.conf > /etc/hosts.d/hblock.md5
fi
