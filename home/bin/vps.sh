#!/usr/bin/env bash

if [ $1 ]; then
	[ ! -d ${HOME}/vps/${1} ] && mkdir -p ${HOME}/vps/${1}
	rsync -aAXvz \
	--exclude={"var/log/journal/","var/cache/apt/","*.mp3",".local/share/Trash/",".local/share/Steam/",".cache/","var/spoll/anacron/","var/log/btmp","var/lib/systemd/random-seed","tmp/backup","usr/bin/ssh-agent","var/cache/yum","/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/var/tmp/","/lost+found",".vzfifo",".cpt_hardlink*",".autorelabel","/etc/shadow","/etc/shadow-","/etc/gshadow","/etc/gshadow-"} \
	root@${1}:/ ${HOME}/vps/${1}
fi
