#!/usr/bin/env bash
#
# Arquivo: autogit.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 13-01-2019 17:03:46
# Última alteração: 13-01-2019 17:03:50

ARQUIVO="$(pwd)/.git/config"

if [ ! -f $ARQUIVO ]; then
	echo "O arquivo $ARQUIVO não existe, abortando..."
	exit
fi

ANTIGO='https://github.com/'
NOVO='git@github.com:'
EXP=$(fgrep -A1 '[remote "origin"]' $ARQUIVO | tail -n1)

if [[ $EXP = *$ANTIGO* ]]; then
    sed -ire "s|${ANTIGO}|${NOVO}|" $ARQUIVO
fi

git add .
git commit
git push origin master
