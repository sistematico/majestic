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

XORG="xorg-server lib32-libxft-bgra libxft-bgra-git"
NVIDIA="nvidia-vulkan nvidia-vulkan-utils"
GNOME="gnome gdm gnome-extra"

PKGS="base base-devel linux linux-headers linux-firmware efibootmgr unzip"
PKGS="${PKGS} dkms intel-ucode grub os-prober ntfs-3g dhcpcd iwd links curl"
PKGS="${PKGS} sudo nano openssh git cronie terminus-font gpm"
PKGS="${PKGS} fortune-mod fortune-mod-chucknorris rtl8192eu-git"

# Xorg
PKGS="${PKGS} ${XORG}"

# Nvidia
PKGS="${PKGS} ${NVIDIA}"

# Gnome
#PKGS="${PKGS} ${GNOME}"

[ ! -f /etc/systemd/network/20-wired.network ] && curl -L -s -o /etc/systemd/network/20-wired.network http://ix.io/3DDk
[ ! -f /etc/systemd/network/loopback-alias.network ] && curl -L -s -o /etc/systemd/network/loopback-alias.network http://ix.io/3DDl
[ ! -L /etc/resolv.conf ] && mv /etc/resolv.conf /var/tmp/resolv-$(date +%s).conf && ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

systemctl --now disable docker
systemctl disable gdm lightdm NetworkManager iwd
systemctl enable systemd-networkd systemd-resolved

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
