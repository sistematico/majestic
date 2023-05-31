#!/usr/bin/env bash
#
# Arquivo: factory-reset.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 16/03/2018 16:35:20
# Última alteração: 05/06/2022 00:20:39

AMD="amd-ucode xf86-video-amdgpu"
XORG="xorg-server xorg-xinit xclip"
XFCE="xfce4 networkmanager network-manager-applet lightdm lightdm-gtk-greeter"
BASE="base base-devel linux linux-headers linux-firmware efibootmgr lvm2 grub os-prober ntfs-3g dhcpcd zsh links curl sudo nano git rsync openssh"
TOPT="feh dunst picom-ibhagwan-git maim dracula-gtk-theme"
OPT="gnome-themes-extra newaita-icons-git starship ttf-ubuntu-font-family ttf-fantasque-sans-mono fortune-mod fortune-mod-chucknorris"

PKGS="${BASE} ${AMD} ${OPT}"

[ ! -f /etc/systemd/network/20-wired.network ] && curl -L -s -o /etc/systemd/network/20-wired.network http://ix.io/3DDk
[ ! -f /etc/systemd/network/loopback-alias.network ] && curl -L -s -o /etc/systemd/network/loopback-alias.network http://ix.io/3DDl
[ ! -L /etc/resolv.conf ] && rm -f /etc/resolv.conf && ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

systemctl --now disable docker podman
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

if [ ! -e /usr/local/bin/ix ]; then
    curl ix.io/client | sudo tee -a /usr/local/bin/ix
    chmod +x /usr/local/bin/ix
fi
