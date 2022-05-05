#!/usr/bin/env bash
#
# Arquivo: dupes.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 02/05/2022 11:52:52
# Última alteração: 02/05/2022 11:52:56

find "$@" ! -empty -type f -exec md5sum {} + | sort | uniq -w32 -dD
