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

downloaded="/var/tmp/unsplash.txt"
mask=$(date +'%Y-%m-%d_%H%M%S')
nome="unsplash-${mask}"
dir="${HOME}/img/unsplash"
arquivo="${dir}/${nome}.jpg"
x=$(xdpyinfo | awk -F '[ x]+' '/dimensions:/{print $3}')
y=$(xdpyinfo | awk -F '[ x]+' '/dimensions:/{print $4}')
max=100
flush=1

[ ! -d $dir ] && mkdir -p $dir

delWall() {
	if [ -f ${HOME}/.unsplash ] && [ -f $(cat ${HOME}/.unsplash) ]; then
        rm -f $(cat ${HOME}/.unsplash)
        rdmWall
    fi
}

rdmWall() {
	arquivo=$dir/$(ls -1 "$dir" | shuf -n1)
	setWall "$arquivo"
}

setWall() {
	if [ "$(file -b --mime-type ${1})" == "image/jpeg" ]; then
		if [ "$DESKTOP_SESSION" == "mate" ]; then
			gsettings set org.mate.background picture-filename "${1}"
		elif [ "$DESKTOP_SESSION" == "gnome" ]; then
			gsettings set org.gnome.desktop.background picture-uri "file://${1}"
		else
			which feh >/dev/null 2>&1 && { feh --bg-fill "${1}"; }
		fi
		echo "${1}" > ${HOME}/.unsplash
	fi
}

flush() {
	if [ $(ls -1 $dir | wc -l) -gt $max ]; then
		rm "$dir/$(ls -Lt1 $dir | tail -1)"
	fi
}

clean() {
	rm -f "${dir}/*.jpg"
}

[ $flush == 1 ] && flush

if [ "$1" == "--delete" ]; then
	delWall
elif [ "$1" == "--clean" ]; then
	clean
elif [ "$1" == "--download" ]; then
	if ! grep -w "$arquivo" $downloaded >/dev/null
	then
		#if WGET "$imgURL"; then
		curl --max-time 120 --connect-timeout 10 -L -s "https://source.unsplash.com/${x}x${y}/?nature,water" > "$arquivo"
		
		if [ "$(file -b --mime-type $arquivo)" != "image/jpeg" ]; then
			rm -f "$arquivo"
		else
			setWall "$arquivo"
			echo "$arquivo" >> $downloaded
		fi
	fi
elif [ "$1" == "--random" ]; then
	rdmWall
fi
