#!/usr/bin/env
#
# Purge snapd

cat <<EOF >/etc/apt/preferences.d/no-snap.pref
# To install snapd, specify its version with 'apt install snapd=VERSION'
# where VERSION is the version of the snapd package you want to install.
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF


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

rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd
