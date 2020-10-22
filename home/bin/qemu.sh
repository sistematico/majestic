#!/usr/bin/env bash

for app in dialog qemu-img qemu-system-x86_64 vinagre
do
    if ! command -v $app >/dev/null;
    then 
        echo "$app não instalado. Instale primeiro."
        exit
    fi
done

NOME="QEMU Helper"

dialog                                                                                 \
        --title 'QEMU Helper'                                                          \
        --msgbox 'Bem vindo QEMU Helper!\n\npor Lucas Saliés Brum a.k.a. sistematico'  \
        0 0

parabens() {
    dialog                                            \
        --title 'Parabéns'                             \
        --msgbox 'Instalação finalizada com sucesso.'  \
        0 0
    clear
    break
}

falhou() {
    dialog                                            \
        --title 'Erro'                             \
        --msgbox 'Instalação falhou.'  \
        0 0
    clear
    break
}

clean() {
    rm -f /tmp/tipo.txt /tmp/kvm.txt /tmp/nome.txt /tmp/iso.txt /tmp/mem.txt /tmp/tamanho.txt
}

cancel() {
    #clean && break
    clean && exit
}

abortar() {
    dialog --title 'Erro' --msgbox "$1" 0 0
}

tipo() {
    tipo=$(dialog  --stdout --title "$NOME" --menu 'Qual o tipo de sistema de arquivos?' 0 0 0 1 'qcow2' 2 'raw')
    
    [ $? -ne 0 ] && cancel

    case "$tipo" in
        1) echo 'qcow2' > /tmp/tipo.txt ;;
        2) echo 'raw' > /tmp/tipo.txt ;;
    esac
}

kvm() {
    kvm=$(dialog  --stdout --title "$NOME" --menu 'Usar o KVM?' 0 0 0 1 'Sim' 2 'Não')
    
    [ $? -ne 0 ] && echo '-enable-kvm' > /tmp/kvm.txt ; exit 0

    case "$kvm" in
        1) echo '-enable-kvm' > /tmp/kvm.txt ;;
        2) echo '' > /tmp/kvm.txt ;;
    esac
}

imagem() {
    while : ; do
        nome=$(dialog --stdout --title "$NOME" --inputbox 'Digite o nome da imagem(Ex.: arch):' 0 0)
        if [ -z $nome ]; then 
            abortar "Insira um nome válido" 
        else 
            echo $nome >/tmp/nome.txt
            break
        fi
        [ $? -ne 0 ] && cancel
    done
}

tamanho() {
    dialog --title "$NOME" --inputbox 'Digite o tamanho da imagem(Ex.: 20G):' 0 0 2>/tmp/tamanho.txt
    [ $? -ne 0 ] && cancel
}

mem() {
    dialog --title "$NOME" --inputbox 'Digite a quantidade de RAM(Ex.: 2G):' 0 0 2>/tmp/mem.txt
    [ $? -ne 0 ] && cancel    
}

iso() {
    while : ; do
        dialog --title "$NOME" --fselect "$HOME" 0 0 2>/tmp/iso.txt 
        
        [ $? -ne 0 ] && cancel

        if [ $(file -b --mime-type $(cat /tmp/iso.txt)) == 'application/x-iso9660-image' ]; then
            break
        else
            abortar "O arquivo $(cat /tmp/iso.txt) não parece ser uma ISO válida!"
        fi
    done
}

executar() {
    if [ -f /tmp/kvm.txt ] && [ -f /tmp/tipo.txt ] && [ -f /tmp/nome.txt ] && [ -f /tmp/iso.txt ] && [ -f /tmp/mem.txt ] && [ -f /tmp/tamanho.txt ]; then
        [ ! -d $HOME/.qemu/images/ ] && mkdir -p $HOME/.qemu/images/
        qemu-img create -f $(cat /tmp/tipo.txt) $HOME/.qemu/images/$(cat /tmp/nome.txt) $(cat /tmp/tamanho.txt) 2> /dev/null
        qemu-system-x86_64 -vnc :0 $(cat /tmp/kvm.txt) -m $(cat /tmp/mem.txt) -cdrom $(cat /tmp/iso.txt) -boot order=d -drive file=$HOME/.qemu/images/$(cat /tmp/nome.txt),format=raw && vinagre 127.0.0.1:5900
        clean
    fi

    [ $? -ne 0 ] && falhou
}

main() {
    imagem
    tipo
	kvm
    tamanho
    mem
    iso
    executar
}

main
