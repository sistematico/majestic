#!/usr/bin/env bash

echo "Packages: $(pacman -Q | wc -l)" > /var/tmp/packages-before.log
echo "---" >> /var/tmp/packages-before.log
pacman -Q >> /var/tmp/packages-before.log

# Mark all as optional
pacman -D --asdeps $(pacman -Qqe)

# Mark specified packages as explicit
#pacman -D --asexplicit base linux linux-firmware efibootmgr intel-ucode lvm2 dhcpcd xorg-server nvidia xorg-xinit bspwm sxhkd git
pacman -D --asexplicit base linux linux-firmware efibootmgr intel-ucode lvm2 dhcpcd

# Remove all except explicit packages
# Note: The arguments -Qt list only true orphans. 
# To include packages which are optionally required by another package, pass the -t flag twice (i.e., -Qtt).
pacman -Rns $(pacman -Qttdq)

# Update all packages
pacman -Syyu
