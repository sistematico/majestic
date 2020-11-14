#!/usr/bin/env bash
#
# Arquivo: factory-reset.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 16/03/2018 16:35:20
# Última alteração: 01/09/2020 00:20:39

log=0
basepkgs="base linux linux-firmware efibootmgr lvm2 intel-ucode btrfs-progs grub dhcpcd nano terminus-font"

if [ $log -eq 1 ]; then
    echo "Packages: $(pacman -Q | wc -l)" > /var/tmp/packages-before.log
    echo "---" >> /var/tmp/packages-before.log
    pacman -Q >> /var/tmp/packages-before.log
fi



read -p "* Deseja instalar uma interface gráfica? [s/N]: " INTERFACE
if [[ $INTERFACE == *[sS]* ]]; then
    interfacepkgs="xorg-server nvidia"
    while :
    do    
	    clear
	    echo "---------------------------------"
	    echo "	     M A I N - M E N U"
	    echo "---------------------------------"
	    echo "1. i3-gaps"
	    echo "2. gnome"
	    echo "3. xfce"
	    echo "4. sair"
	    echo "---------------------------------"
	    read -r -p "Escolha uma opção [1-4] : " pacotesinterface
        case $pacotesinterface in
		    1)
                interfacepkgs="$interfacepkgs i3-gaps"
		    ;;
		    2)
		        interfacepkgs="$interfacepkgs gnome"
		    ;;
		    3)
		        interfacepkgs="$interfacepkgs xfce4"		
		    ;;
		    4)
		        break
		    ;;
		    *)
		        echo "Escolha de 1 a 4 apenas"
	    esac
    done
fi

read -p "* Deseja instalar mais algum pacote? [s/N]: " ADICIONAL
if [[ $ADICIONAL == *[sS]* ]]; then
    while :
    do    
	    read -r -p "Escolha uma opção [1-4] : " pacotesinterface
        case $pacotesinterface in
		    1)
                interfacepkgs="$interfacepkgs i3-gaps"
		    ;;
		    2)
		        interfacepkgs="$interfacepkgs gnome"
		    ;;
		    3)
		        interfacepkgs="$interfacepkgs xfce4"		
		    ;;
		    4)
		        break
		    ;;
		    *)
		        echo "Escolha de 1 a 4 apenas"
	    esac
    done
fi

read -p "* Tem certeza que deseja continuar? [s/N]: " CONTINUAR
if [[ $INTERFACE == *[sS]* ]]; then
    # Mark all as optional
    pacman -D --asdeps $(pacman -Qqe)

    # Mark base packages as explicit
    pacman -D --asexplicit $basepkgs $interfacepkgs $optionalpkgs

    # Remove all except explicit packages
    # Note: The arguments -Qt list only true orphans. 
    # To include packages which are optionally required by another package, pass the -t flag twice (i.e., -Qtt).
    pacman -Rns $(pacman -Qttdq)

    # Update all packages
    pacman -Syyu
else
    echo "Programa abortado."
fi
