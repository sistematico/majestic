#!/usr/bin/env bash
#
# Arquivo: gradientes.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 31/10/2018 11:46:24
# Última alteração: 17/07/2019 15:54:12

gradientes=(
	'#c79081 #dfa579'
	'#bdc3c7 #2c3e50'
	'#0F2027 #2C5364'
	'#373B44 #4286f4'
	'#0f0c29 #302b63'
	'#bdc3c7 #2c3e50'
)

gradiente=${gradientes[$RANDOM % ${#gradientes[@]}]}
primeiro=$(echo $gradiente | awk '{print $1;}')
segundo=$(echo $gradiente | awk '{print $NF}')

hsetroot -add "$primeiro" -add "$segundo" -gradient 0
