#!/usr/bin/env bash
#
# Arquivo: factory-reset.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 16/03/2018 16:35:20
# Última alteração: 01/09/2020 00:20:39

# base base-devel linux linux-firmware efibootmgr 
# dmks lvm2 intel-ucode btrfs-progs grub dhcpcd 
# sudo nano openssh git cronie terminus-font 
# xorg-server xorg-xinit nvidia 
# i3-gaps-rounded-git polybar-git feh dunst picom-ibhagwan-git 
# rofi rofi-greenclip ttf-fantasque-sans-mono headsetcontrol-git imagemagick maim fortune-mod fortune-mod-chucknorris gnome-themes-extra dracula-gtk-theme ttf-dejavu rtl8192eu-git"

XORG="xorg-server"
NVIDIA="nvidia"
GNOME="gnome gdm gnome-extra"

PKGS="base base-devel linux linux-headers linux-firmware efibootmgr unzip"
PKGS="${PKGS} dkms intel-ucode grub os-prober ntfs-3g dhcpcd iwd links"
PKGS="${PKGS} sudo nano openssh git cronie terminus-font gpm"
PKGS="${PKGS} headsetcontrol-git fortune-mod"
PKGS="${PKGS} fortune-mod-chucknorris rtl8192eu-git"

# Xorg
#PKGS="${PKGS} ${XORG}

# Nvidia
#PKGS="${PKGS} ${NVIDIA}"

# Gnome
#PKGS="${PKGS} ${GNOME}"

systemctl --now disable docker
systemctl disable gdm lightdm
systemctl enable systemd-networkd

echo "Packages: $(pacman -Q | wc -l)" > /var/tmp/packages-before.log
echo "---" >> /var/tmp/packages-before.log
pacman -Q >> /var/tmp/packages-before.log

# Mark all as optional
pacman -D --asdeps $(pacman -Qqe)

# Mark base packages as explicit
pacman -D --asexplicit $PKGS

# Remove all except explicit packages
# Note: The arguments -Qt list only true orphans. 
# To include packages which are optionally required by another package, pass the -t flag twice (i.e., -Qtt).
pacman -Rns $(pacman -Qttdq)

# Update all packages
pacman -Syyu
