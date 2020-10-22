#!/usr/bin/env bash
#
# unsplash.sh - Script para alterar o papel de parede uma imagem aleatória do site unsplash.com
#
# Desenvolvido por Lucas Saliés Brum <lucas@archlinux.com.br>
#
# Criado em: 20/12/2017 19:27:31 
# Última Atualização: 03/05/2018 17:36:08
#
# Créditos:
# - https://unix.stackexchange.com/a/366655
# - https://stackoverflow.com/a/3077316
# - https://stackoverflow.com/a/3919908
# - https://stackoverflow.com/a/27671738

which wget >/dev/null 2>&1 || { echo >&2 "O programa xdpyinfo não está instalado. Abortando."; exit 1; }
which xdpyinfo >/dev/null 2>&1 || { echo >&2 "O programa xdpyinfo não está instalado. Abortando."; exit 1; }
which file >/dev/null 2>&1 || { echo >&2 "O programa file não está instalado. Abortando."; exit 1; }

mask=$(date +'%Y-%m-%d_%H%M%S')
nome="unsplash-${mask}"
dir="${HOME}/img/unsplash"
arquivo="${dir}/${nome}.jpg"
x=$(xdpyinfo | awk -F '[ x]+' '/dimensions:/{print $3}')
y=$(xdpyinfo | awk -F '[ x]+' '/dimensions:/{print $4}')
max=10
clean=1

[ ! -d $dir ] && mkdir -p $dir

setWallpaper() {
	if [ -f "$1" ]; then
		if [ "$DESKTOP_SESSION" == "mate" ]; then 
			gsettings set org.mate.background picture-filename "$1"
		elif [ "$DESKTOP_SESSION" == "gnome" ]; then 
			wallpaper="file://${1}"
			gsettings set org.gnome.desktop.background picture-uri "$wallpaper"
		else
			which feh >/dev/null 2>&1 && { feh --bg-fill "$1"; }
		fi  
	fi
}

read() {
	arquivo="$(cat ${HOME}/.unsplash)"
}

write() {
	echo "$1" > ${HOME}/.unsplash
}

flush() {
	if [ $(ls -1 $dir | wc -l) -gt $max ]; then
		echo "Mais que $max"
		echo "Apagando o último: $(ls -Lt1 $dir | tail -1)"
		rm "$dir/$(ls -Lt1 $dir | tail -1)"
	fi
}

clean() {
	rm -f "${dir}/*.jpg"
}

if [ $clean == 1 ]; then
	flush
fi

if [ "$1" == "--clean" ]; then
	clean
elif [ "$1" == "--download" ]; then
	curl -L -s "$url_real" > "$arquivo"
	#write "$arquivo"
	setWallpaper "$arquivo"
elif [ "$1" == "--random" ]; then
	arquivo=$dir/$(ls -t1 "$dir" | shuf -n1)
	#write "$arquivo"
	setWallpaper "$arquivo"
fi