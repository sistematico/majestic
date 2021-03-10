#!/usr/bin/env bash
#
# Arquivo: gradientes.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 31/10/2018 11:46:24
# Última alteração: 17/07/2019 15:54:12

function randColor () {
	RANDC=$(printf "%02x%02x%02x\n" $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))
	echo "#"$RANDC
}

cor1=$(randColor)
cor2=$(randColor)

if [ "$1" == "-r" ] && [ -f $HOME/.randwall ]; then
	cor1=$(awk 'NR==1' $HOME/.randwall)
	cor2=$(awk 'NR==2' $HOME/.randwall)
else
	echo "$cor1" > $HOME/.randwall
	echo "$cor2" >> $HOME/.randwall
fi

hsetroot -add "$cor1" -add "$cor2" -gradient 0
