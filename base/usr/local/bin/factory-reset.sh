#!/usr/bin/env bash
#
# Arquivo: /usr/local/bin/factory-reset
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Uso: curl -s -L https://git.io/JtrjF | bash
#
# Criado em: 16/03/2018 16:35:20
# Última alteração: 10/02/2021 02:05:36

VERSION="1.1"
BASE="base linux linux-firmware efibootmgr lvm2 intel-ucode btrfs-progs grub nano"
OPTIONAL="git rxvt-unicode terminus-font bash-completion"

vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

if [ ! -x /usr/local/bin/factory-reset ]; then
    NEWVERSION="$VERSION"
    source /usr/local/bin/factory-reset
    OLDVERSION="$VERSION"

    vercomp $NEWVERSION $OLDVERSION
    case $? in
        0) echo "Programa atualizado.";;
        1) echo "A versão local é mais nova que a versão dos repositórios.";;
        2) DESATUALIZADO=s ; echo "Programa desatualizado";;
    esac
fi

echo

if [ ! -x /usr/local/bin/factory-reset ] || [ ! -z "$DESATUALIZADO" ]; then
    while :
    do    
        #clear
        echo "------------------------------------"
        echo "	   F A C T O R Y - R E S E T"
        echo "------------------------------------"
        echo "1. Instalar"
        echo "2. Instalar & Executar"
        echo "3. Sair"
        echo "------------------------------------"
        read -r -p "Escolha uma opção [1-3] : " INSTALAR

        case $INSTALAR in
            1)
                curl -s -L https://raw.githubusercontent.com/sistematico/majestic/master/base/usr/local/bin/factory-reset.sh > /usr/local/bin/factory-reset
                chmod +x /usr/local/bin/factory-reset
                exit
            ;;
            2)
                curl -s -L https://raw.githubusercontent.com/sistematico/majestic/master/base/usr/local/bin/factory-reset.sh > /usr/local/bin/factory-reset
                chmod +x /usr/local/bin/factory-reset
                break
            ;;
            3)
                echo "Programa abortado."
                exit
            ;;
            *)
                echo "Escolha de 1 a 3 apenas"
        esac
    done
fi

[ "$1" == "-n" ] || [ "$1" != "-i" ] && DRYRUN="s" || DRYRUN="n"

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
    INTERFACE="xorg-server nvidia"

    while :
    do    
        clear
        echo "------------------------------------"
        echo "	     I N T E R F A C E"
        echo "------------------------------------"
        echo "1. i3 (gaps)"
        echo "2. GNOME"
        echo "3. XFCE"
        echo "4. MATE"
        echo "5. Sair"
        echo "------------------------------------"
        read -r -p "Escolha uma opção [1-5] : " pacotesinterface

        case $pacotesinterface in
            1)
                INTERFACE="$INTERFACE i3-gaps xorg-xinit"
                break
            ;;
            2)
                INTERFACE="$INTERFACE gnome gdm"
                break
            ;;
            3)
                INTERFACE="$INTERFACE xfce4 lightdm lightdm-gtk-greeter"
                break		
            ;;
            4)
                INTERFACE="$INTERFACE mate lightdm lightdm-gtk-greeter"
                break
            ;;
            5)
                break
            ;;
            *)
                echo "Escolha de 1 a 5 apenas"
        esac
    done
fi

clear
read -p "* Deseja instalar mais algum pacote? [s/N]: " ADICIONAL
if [[ $ADICIONAL == *[sS]* ]]; then
    while :
    do
        clear    
        read -r -p "Digite o nome dos pacotes separados por espaços: " NEW_OPTIONAL

        echo "Os seguintes pacotes foram adicionados:"
        echo
        echo "$NEW_OPTIONAL"
        echo
        
          read -r -p "Estes pacotes estão corretos? [s/N]: " pacotesadicionaisok
        if [[ $pacotesadicionaisok == *[sS]* ]]; then
            break
        fi
    done
fi

OPTIONAL="$OPTIONAL $NEW_OPTIONAL"

clear
read -p "* Tem certeza que deseja continuar? [s/N]: " CONTINUAR
if [[ $CONTINUAR == [sS]* ]]; then

    echo "Você está prestes a remover todos os pacotes e instalar os seguintes: "
    echo 
    echo "Base     : $BASE"
    echo "Interface: $INTERFACE"
    echo "Opcionais: $OPTIONAL"
    echo
    read -r -p "Deseja continuar? [s/N]: " continuar

    if [[ "$continuar" != [sS]* ]]; then
        echo "Programa abortado."
        exit
    fi

    if [ "$DRYRUN" == "n" ]; then
        read -r -e -p "Você tem CERTEZA ABSOLUTA que deseja continuar?\nTodos os pacotes exceto os pacotes básicos, interface e opcionais que você escolheu serão completamente removidos do seu sistema! [s/N]: " continuar

        if [[ "$continuar" != [sS]* ]]; then
            echo "Programa abortado."
            exit
        fi

        # Mark all as optional
        echo "Marcando todos os pacotes como opcionais: "
        pacman -D --asdeps $(pacman -Qqe)

        # Mark base packages as explicit
        echo "Marcando como explícitos os pacotes: "
        echo "$BASE $INTERFACE $OPTIONAL"
        pacman -D --asexplicit $BASE

        # Remove all except explicit packages
        # Note: The arguments -Qt list only true orphans. 
        # To include packages which are optionally required by another package, pass the -t flag twice (i.e., -Qtt).
        echo "Removendo todos os pacotes excetos os explícitos: "
        pacman -Rns $(pacman -Qttdq)

        # Update all packages
        echo "Atualizando todos os pacotes instalados: "
        echo "pacman -Syyu"

        if [ -z "$INTERFACE" ]; then
            pacman -S $INTERFACE
        fi

        if [ -z "$OPTIONAL" ]; then
            pacman -S $OPTIONAL
        fi

        if [[ $GRAVARLOG != *[nN]* ]]; then
            echo "Packages: $(pacman -Q | wc -l)" > /var/tmp/packages-after.log
            echo "---" >> /var/tmp/packages-after.log
            pacman -Q >> /var/tmp/packages-after.log
            echo "Logs gravados em /var/tmp/packages-before.log e /var/tmp/packages-after.log"
        fi

        echo "Obrigado por usar o factory-reset!"
    else
        echo
        echo "Rodando em Dry-Run..."
        echo
        echo "Seriam marcados como pacotes explicitamente instalados:"
        echo
        echo "Base     : $BASE"
        echo "Interface: $INTERFACE"
        echo "Opcional : $OPTIONAL"
        echo
    fi
else
    echo "Programa abortado."
fi
