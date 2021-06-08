#!/usr/bin/env
#
# Purge snapd

systemctl --now disable \ 
snapd.apparmor.service \ 
snapd.autoimport.service \ 
snapd.core-fixup.service \ 
snapd.failure.service \ 
snapd.recovery-chooser-trigger.service \ 
snapd.seeded.service \ 
snapd.service \ 
snapd.snap-repair.service \ 
snapd.system-shutdown.service \ 
snapd.socket \ 
snapd.snap-repair.timer 

umount /snap/core* -lf

snap remove gnome-3-34-1804
snap remove gtk-common-themes
snap remove snapd
snap remove snap-store
snap remove core
snap remove core18

apt remove snapd --purge

rm -rf /var/lib/snapd
rm -rf /var/snap