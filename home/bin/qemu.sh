#!/usr/bin/env bash
#
# Arquivo: qemu.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <sistematico@gmail.com>
#
# Criado em: 10/08/2022 17:12:29
# Última alteração: 10/08/2022 17:12:33

TITLE='QEMU_Helper'
DIALOG="dialog --keep-tite --backtitle ${TITLE}"
TIMEOUT=2

for app in dialog qemu-img qemu-system-x86_64 vinagre
do
    if ! command -v $app >/dev/null;
    then 
        echo "$app não instalado. Instale primeiro."
        exit
    fi
done

# [ ! -f $HOME/.dialogrc ] && curl -sLo $HOME/.dialogrc https://raw.githubusercontent.com/sistematico/majestic/master/dialog/.local/share/dialog/themes/green.cfg
# export DIALOGRC=$HOME/.dialogrc

$DIALOG \
    --timeout $TIMEOUT \
    --title 'QEMU Helper' \
    --msgbox 'Bem vindo QEMU Helper!\n\npor Lucas Saliés Brum a.k.a. sistematico' \
    0 0

debug() {
    echo "Chegou aqui"
    exit
}

parabens() {
    $DIALOG \
        --timeout $TIMEOUT \
        --title 'Parabéns' \
        --msgbox 'Instalação finalizada com sucesso.' \
        0 0
    clear
    break
}

falhou() {
    $DIALOG \
        --timeout $TIMEOUT \
        --title 'Erro' \
        --msgbox 'Instalação falhou.' \
        0 0
    clear
    break
}

clean() {
    rm -f /tmp/tipo.txt /tmp/kvm.txt /tmp/iso.txt /tmp/mem.txt /tmp/disco.txt
}

cancel() {
    clean
    exit
}

abortar() {
    $DIALOG --timeout 5 --title 'Erro' --msgbox "$1" 0 0
}

imagem() {
    while : ; do
        nome=$($DIALOG --stdout --title "Nome da imagem" --inputbox 'Digite o nome da imagem(Ex.: arch):' 0 0 'rocky')
        [ $? -ne 0 ] && cancel
        [ -z "$nome" ] && abortar "Insira um nome válido" || break
    done
}

tipo() {
    tipo=$($DIALOG  --stdout --title "Tipo de imagem" --menu 'Qual o tipo de sistema de arquivos?' 0 0 0 1 'qcow2' 2 'raw')

    [ $? -ne 0 ] && cancel
    
    if [ "$tipo" != "qcow2" ] && [ "$tipo" != "raw" ]; then
        echo 'qcow2' > /tmp/tipo.txt
    else
        echo "$tipo" > /tmp/tipo.txt
    fi
}

kvm() {
    enablekvm=$($DIALOG  --stdout --title "KVM" --menu 'Usar o KVM?' 0 0 0 1 'Sim' 2 'Não')
    
    [ $? -ne 0 ] && exit

    case $enablekvm in
        1) 
            echo '-enable-kvm' > /tmp/kvm.txt
        ;;
        2) 
            echo '' > /tmp/kvm.txt
        ;;
        *)
            echo '-enable-kvm' > /tmp/kvm.txt
        ;;
    esac
}

disco() {
    while : ; do
        disco=$($DIALOG --stdout --title 'Tamanho do disco' --inputbox 'Tamanho do disco(Ex.: 20G):' 0 0 '20G')
        
        [ $? -ne 0 ] && cancel
        
        [ -z "$disco" ] && abortar "Erro" || break
        
        #tamanho=$(echo "$disco" | sed 's/[^0-9]*//g')
        #sufixo=$(echo "$disco" | sed 's/[^A-Z]//g' | sed 's/^\(.\{1\}\).*/\1/')

        #[ -z "$tamanho" ] && abortar "Tamanho inválido." || break
        
        
        # if [ "$sufixo" != "M" ] && [ "$sufixo" != "G" ]; then
        #     abortar "Sufixo inválido, use 'M' ou 'G'."
        # else
        #     break
        # fi
    done
}

mem() {
    while : ; do
        memoria=$($DIALOG --stdout --title 'Capacidade de memória' --inputbox 'Ex.: 2G' 0 0 '2G')
        memoria=$(echo "$memoria" | sed 's/[^0-9]*//g')
        [ $? -ne 0 ] && cancel    
        [ ! -z "$memoria" ] && break    
    done
}

iso() {
    [ -d $HOME/iso ] && iso=$HOME/iso || iso=$HOME

    while : ; do       
        iso=$($DIALOG --stdout --title 'Selecione a imagem ISO' --fselect "$iso" 0 80)

        [ -z "$iso" ] && abortar "Selecione uma imagem iso."

        if [ $(file -b --mime-type $iso) == 'application/x-iso9660-image' ]; then
            break
        else
            abortar "O arquivo $iso não parece ser uma ISO válida!"
        fi
    done
}

executar() {
    if [ -f /tmp/kvm.txt ] && \
        [ -f /tmp/tipo.txt ] && \
        [ ! -z "$nome" ] && \
        [ ! -z "$iso" ] && \
        [ ! -z "$memoria" ] && \
        [ ! -z "$disco" ]; then
            [ ! -d $HOME/.qemu/images/ ] && mkdir -p $HOME/.qemu/images/
            qemu-img create -f $(cat /tmp/tipo.txt) "$HOME/.qemu/images/$nome" "$disco" 2> /dev/null
            qemu-system-x86_64 -vnc :0 $(cat /tmp/kvm.txt) -m $memoria -cdrom "$iso" -boot order=d -drive file=$HOME/.qemu/images/$nome,format=$(cat /tmp/tipo.txt) && vinagre 127.0.0.1:5900
    else
        falhou
    fi
}

principal() {
    imagem
    tipo
	kvm
    disco
    mem
    iso
    executar
}

principal
