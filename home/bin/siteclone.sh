#!/usr/bin/env bash
#################################################################################
#                                                                              #
# siteclone.sh                                                                 #
#                                                                              #
# Criado em: 18/06/2020 2:05:37 am                                             #
# Modificado em: 18/06/2020 2:39:23 am                                         #
#                                                                              #
# Por Lucas Saliés Brum                                                        #
# -----                                                                        #
# CC BY-NC-SA 2020 Lucas Saliés Brum a.k.a. sistematico lucas@archlinux.com.br #
#                                                                              #
# Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)     #
#################################################################################

wget --wait=2 \
	--level=inf \
	--limit-rate=20K \
	--recursive \
	--page-requisites \
	--user-agent=Mozilla \
	--no-parent \
	--convert-links \
	--adjust-extension \
	--no-clobber \
	-e robots=off \
	--continue \
	"$1"
