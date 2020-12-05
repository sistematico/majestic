#!/usr/bin/env bash
#
# Arquivo: factory-reset.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 16/03/2018 16:35:20
# Última alteração: 01/09/2020 00:20:39

basepkgs="base linux linux-firmware efibootmgr lvm2 intel-ucode btrfs-progs grub nano"
#optionailpkgs="git rxvt-unicode terminus-font bash-completion"

dryrun="n"

clear
read -p "* Gravar todas as alterações em log? [S/n]: " GRAVARLOG
if [[ $GRAVARLOG != *[nN]* ]]; then
    echo "Packages: $(pacman -Q | wc -l)" > /var/tmp/packages-before.log
    echo "---" >> /var/tmp/packages-before.log
    pacman -Q >> /var/tmp/packages-before.log
fi

clear
read -p "* Deseja instalar uma interface gráfica? [s/N]: " INTERFACE
if [[ $INTERFACE == *[sS]* ]]; then
    interfacepkgs="xorg-server nvidia"
    while :
    do    
	    clear
	    echo "------------------------------------"
	    echo "	     I N T E R F A C E"
	    echo "------------------------------------"
	    echo "1. i3-gaps"
	    echo "2. gnome"
	    echo "3. xfce"
        echo "3. mate"
	    echo "4. sair"
	    echo "------------------------------------"
	    read -r -p "Escolha uma opção [1-4] : " pacotesinterface
        case $pacotesinterface in
		    1)
                interfacepkgs="$interfacepkgs i3-gaps xorg-xinit"
                break
		    ;;
		    2)
		        interfacepkgs="$interfacepkgs gnome gdm"
                break
		    ;;
		    3)
		        interfacepkgs="$interfacepkgs xfce4 lightdm lightdm-gtk-greeter"
                break		
		    ;;
		    4)
                interfacepkgs="$interfacepkgs mate lightdm lightdm-gtk-greeter"
		        break
		    ;;
		    3)
		        break
		    ;;
		    *)
		        echo "Escolha de 1 a 4 apenas"
	    esac
    done
fi

clear
read -p "* Deseja instalar mais algum pacote? [s/N]: " ADICIONAL
if [[ $ADICIONAL == *[sS]* ]]; then
    while :
    do
        clear    
	    read -r -p "Digite o nome dos pacotes separados por espaços: " newoptionalpkgs

        echo "Os seguintes pacotes foram adicionados:"
        echo
        echo "$newoptionalpkgs"
        echo
        
  	    read -r -p "Estes pacotes estão corretos? [s/N]: " pacotesadicionaisok
        if [[ $pacotesadicionaisok == *[sS]* ]]; then
            break
        fi
    done
fi

optionailpkgs="$optionailpkgs $newoptionalpkgs"

clear
read -p "* Tem certeza que deseja continuar? [s/N]: " CONTINUAR
if [[ $CONTINUAR == [sS]* ]]; then

    echo "Você está prestes a remover todos os pacotes e instalar os seguintes: "
    echo 
    echo "Base: $basepkgs"
    echo "Interface: $interfacepkgs"
    echo "Opcionais: $optionalpkgs"
    echo
    read -r -p "Deseja continuar? [s/N]: " continuar

    if [[ "$continuar" != [sS]* ]]; then
        echo "Programa abortado."
        exit
    fi

    if [ "$dryrun" == "n" ]; then
        # Mark all as optional
        echo "Marcando todos os pacotes como opcionais"
        pacman -D --asdeps $(pacman -Qqe)

        # Mark base packages as explicit
        echo "Marcando como explícitos os pacotes: "
        echo "$basepkgs $interfacepkgs $optionalpkgs"
        pacman -D --asexplicit $basepkgs

        # Remove all except explicit packages
        # Note: The arguments -Qt list only true orphans. 
        # To include packages which are optionally required by another package, pass the -t flag twice (i.e., -Qtt).
        echo "Removendo todos os pacotes excetos os explícitos"
        pacman -Rns $(pacman -Qttdq)

        # Update all packages
        echo "Atualizando todos os pacotes instalados"
        pacman -Syyu

		if [ -z "$interfacepkgs" ] || [ -z "$optionalpkgs" ]; then
			pacman -S $interfacepkgs $optionalpkgs
		fi
    else
        echo
        echo "Rodando em Dry-Run..."
        echo "Seriam marcados como pacotes explicitamente instalados:"
        echo
        echo "Base: $basepkgs"
        echo "Interface: $interfacepkgs"
        echo "Opcional: $optionalpkgs"
        echo
    fi
else
    echo "Programa abortado."
fi
