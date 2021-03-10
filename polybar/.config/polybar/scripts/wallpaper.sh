#!/usr/bin/env bash
#
# wallpaper.sh - Um programa para alterar o papel de parede no i3 para ser usado em conjunto com a polybar.
#
# Criador por Lucas Saliés Brum a.k.a. sistematico, <lucas at archlinux dot com dot br>
#
# Criado em: 15/03/2018 18:15:04
# Última alteração: 25/01/2019 11:17:14

ajuda() {
    echo
    echo "Uso: $(basename $0) [d][dd][r][rr][n][p][a]"
    echo 
    exit
}

if [ "$1" == "-h" ]; then
	ajuda
fi

[ -f ~/.config/user-dirs.dirs ] && source ~/.config/user-dirs.dirs

dir="${XDG_PICTURES_DIR:-${HOME}/img/wallhaven}"
unsplash_dir="${XDG_PICTURES_DIR:-${HOME}/img}/wallpapers/unsplash"
default="$HOME/.local/share/wallpapers/i3.png"
ultima="/home/lucas/img/wallpapers/astronaut-jellyfish-space-digital-art-uhdpaper.com-4K-107.jpg"
modo="--bg-fill"
indice=0
i=0
x=$(xdpyinfo | grep dimensions | awk '{print $2}' | awk -F'x' '{print $1}')
y=$(xdpyinfo | grep dimensions | awk '{print $2}' | awk -F'x' '{print $2}')
icone="${HOME}/.local/share/icons/elementary/camera-photo.png"

ajustar() {
	if [ -f "$1" ]; then
		sed -i "s|^ultima=.*|ultima=\"${1}\"|g" $0
		command -v feh >/dev/null 2>&1 || { notify-send -i $icone "Erro" "O aplicativo feh não está instalado." ; exit 1; }
		feh --bg-fill "$1"
		echo "$1" > ~/.wall
	fi
}

if [ "$2" ]; then
	[ -d $2 ] && dir=$2
else
	[ ! -d $dir ] && mkdir -p $dir
fi

[ ! -d $unsplash_dir ] && mkdir -p $unsplash_dir
[ ! -d $(dirname $default) ] && mkdir -p $(dirname $default)
[ ! -f $default ] && curl -s -L 'http://i.imgur.com/BwOh5Z5.png' > $default
#[ ! -f $default ] && curl -s -L 'https://unsplash.com/photos/mEV-IXdk5Zc/download?force=true' > $default

while read linha; do
    imagens[$i]="$linha"
    ((i++))
done < <(find "$dir/" -type f \( -iname \*.jpg -o -iname \*.png -o -iname \*.jpeg \) )

cont=${#imagens[@]}
total=$((cont-1))

if [ $cont -gt 0 ]; then
	for i in "${!imagens[@]}"; do
   		if [[ "${imagens[$i]}" = "${ultima}" ]]; then
       		indice=${i}
   		fi
	done
else
	echo "Nenhuma imagem."
	exit 1
fi

if [ ! $1 ]; then
	img=${imagens[$RANDOM % ${#imagens[@]}]}
elif [ "$1" == "d" ]; then
	img="$unsplash_dir/unsplash-$$.jpg"
	curl -L -s "https://unsplash.it/${x}/${y}?random" > $img
	notify-send -i $icone "Sucesso" "Imagem <b>$img</b> baixada."
elif [ "$1" == "dd" ]; then
	apagar=$(echo -e "Sim\nNão" | rofi -p "Apagar $(basename $(cat ~/.wall))?" -dmenu -bw 0 -lines 2 -width 400 -separator-style none -location 0 -hide-scrollbar -padding 5)
	if [ "$apagar" == "Sim" ]; then
		rm $(cat ~/.wall)
		notify-send -i $icone "Sucesso" "Imagem <b>$(basename $(cat ~/.wall))</b> apagada."
		command -v hsetroot >/dev/null 2>&1 || { notify-send -i $icone "Erro" "O aplicativo hsetroot não está instalado." ; exit 1; }
		hsetroot -solid "#2e3440"
		echo $default > $HOME/.wall
	fi
elif [ "$1" == "rr" ]; then
	if [ ! -f $HOME/.wall ] || [ ! -f $(cat $HOME/.wall) ]; then
		echo $default > $HOME/.wall
	fi
	img=$default
elif [ "$1" == "x" ]; then
	command -v hsetroot >/dev/null 2>&1 || { notify-send -i $icone "Erro" "O aplicativo hsetroot não está instalado." ; exit 1; }
	hsetroot -solid "#2e3440"
elif [ "$1" == "a" ]; then
	if [ $indice -gt 0 ]; then
		((indice--))
	else
		indice=$total
	fi
	img=${imagens[$indice]}
elif [ "$1" == "p" ]; then
	if [ $indice -lt $total ]; then
		((indice++))
	else
		indice=0
	fi
	img=${imagens[$indice]}
elif [ "$1" == "r" ]; then
	if [ ! -f $HOME/.wall ] || [ ! -f $(cat $HOME/.wall) ]; then
		echo $default > $HOME/.wall
	fi
	img=$(cat $HOME/.wall)
fi

ajustar "$img"
