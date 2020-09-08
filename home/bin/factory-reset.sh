#!/usr/bin/env bash
#
# Arquivo: factory-reset.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 16/03/2018 16:35:20
# Última alteração: 01/09/2020 00:20:39

echo "Packages: $(pacman -Q | wc -l)" > /var/tmp/packages-before.log
echo "---" >> /var/tmp/packages-before.log
pacman -Q >> /var/tmp/packages-before.log

# Mark all as optional
pacman -D --asdeps $(pacman -Qqe)

# Mark specified packages as explicit
#pacman -D --asexplicit base linux linux-firmware efibootmgr intel-ucode lvm2 dhcpcd xorg-server nvidia xorg-xinit bspwm sxhkd git
pacman -D --asexplicit base linux linux-firmware efibootmgr intel-ucode lvm2 dialog sudo nano dhcpcd grub os-prober ntfs-3g grub-theme-vimix

# Remove all except explicit packages
# Note: The arguments -Qt list only true orphans. 
# To include packages which are optionally required by another package, pass the -t flag twice (i.e., -Qtt).
pacman -Rns $(pacman -Qttdq)

# Update all packages
pacman -Syyu
