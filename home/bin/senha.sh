#!/usr/bin/env bash
#
# Arquivo: syshw.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 16/03/2018 16:35:20
# Última alteração: 01/09/2020 00:20:17

chars=32
senha="$(openssl rand -base64 $chars)"

echo "${senha}" | xclip -selection clipboard -rmlastnl
echo $senha
