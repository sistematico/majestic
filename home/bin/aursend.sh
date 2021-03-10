#!/usr/bin/env bash
#
# Arquivo: aursend.sh
# Script para o envios de pacotes para o AUR.
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 16-05-2016 13:10:01
# Última alteração: 13-01-2019 17:02:02

if [ ! "$1" ]; then
	echo "Parametros insuficientes..."
	exit 1
fi

pacote=$1
nome=$(cat cerebro/.SRCINFO | grep pkgname | cut -d ' ' -f 3)
build=$(date +"%Y%m%d")

mv $pacote ${pacote}.old
git clone git+ssh://aur@aur.archlinux.org/${pacote}.git
cp ${pacote}.old/PKGBUILD ${pacote}/ 
cd $pacote
makepkg --printsrcinfo > .SRCINFO
git add PKGBUILD .SRCINFO
git commit -m "Pacote: ${nome} Build: ${build}"
git push
