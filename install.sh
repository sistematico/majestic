#!/usr/bin/env bash
#
# Instala os dotfiles usando o GNU Stow
#
# Por Lucas Saliés Brum, a.k.a. sistematico, <lucas@archlinux.com.br>


ajuda() {
	echo
	echo "Uso: $(basename $0) [pacote1] [pacote2] [pacote3]"
	echo
	echo "Exemplo: $(basename $0) i3 polybar rofi"
	echo
	echo "Pacotes disponíveis: bash compton dunst fontes gtk home i3 mpd polybar qutebrowser ranger rofi startpage systemd termite tmux thunar"
	echo
	exit 0
}

[ ! $1 ] && ajuda

pacotes=("$@")

for p in "${pacotes[@]}"; do
	if [ -d $p ]; then
		stow $p
		echo "Pacote: ${p} instalado."
	else
		echo "Pacote: $p não encontrado."
	fi
done