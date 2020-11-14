#!/usr/bin/env bash
#
# Arquivo: factory-reset.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 16/03/2018 16:35:20
# Última alteração: 01/09/2020 00:20:39

log=0

if [ $log -eq 1 ]; then
    echo "Packages: $(pacman -Q | wc -l)" > /var/tmp/packages-before.log
    echo "---" >> /var/tmp/packages-before.log
    pacman -Q >> /var/tmp/packages-before.log
fi

# Mark all as optional
pacman -D --asdeps $(pacman -Qqe)

# Mark base packages as explicit
pacman -D --asexplicit base linux linux-firmware efibootmgr lvm2 intel-ucode btrfs-progs grub dhcpcd nano terminus-font

read -p "Deseja : " IDADE

while :
do
    read -p "* Deseja instalar uma interface gráfica? [s/N]: " INTERFACE
    if [  ]; then
        break
    fi
done

pacman -D --asexplicit sudo ntfs-3g

# Remove all except explicit packages
# Note: The arguments -Qt list only true orphans. 
# To include packages which are optionally required by another package, pass the -t flag twice (i.e., -Qtt).
pacman -Rns $(pacman -Qttdq)

# Update all packages
pacman -Syyu
