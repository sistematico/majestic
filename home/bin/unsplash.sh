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
max=100
clean=1

[ ! -d $dir ] && mkdir -p $dir

if [ "$1" != "--flush" ] && [ $clean == 1 ]; then
    if [ $(ls -1 $dir | wc -l) -gt $max ]; then
	    echo "Mais que $max"
	    echo "Apagando o último: $(ls -Lt1 $dir | tail -1)"
	    rm "$dir/$(ls -Lt1 $dir | tail -1)"
    fi
fi

url="https://source.unsplash.com/${x}x${y}/?nature,water"
url_real=$(curl -Ls -o /dev/null -w %{url_effective} "$url")
query_string=(${url_real//[=&]/ })

#for x in "${!query_string[@]}"; do printf "[%s]=%s\n" "$x" "${query_string[$x]}" ; done

	for ((i=0; i<${#query_string[@]}; i+=2))
	do
		if [ $query_string[i] == 'ixid' ]; then
    		declare var_${query_string[i]}=${query_string[i+1]}
		fi
	done


echo $var_ixid

if [ "$1" == "-d" ]; then
	for ((i=0; i<${#query_string[@]}; i+=2))
	do
    	declare var_${query_string[i]}=${query_string[i+1]}
	done

	#wget -q -p "$dir" -O - "$url" 2>&1 | grep "Content-Disposition:" | tail -1 | awk -F"filename=" '{print $2}'
	wget -q -p "$dir" "$url"

	ls -t1 "$dir" | head -n 1
	#curl -L -s "$url" > $arquivo
	#curl -O -J -L $url
	#echo $arquivo > ~/.unsplash
elif [ "$1" == "--random" ]; then
	arquivo=$dir/$(ls -t1 "$dir" | shuf -n1)
	[ -f $arquivo ] && echo $arquivo > ~/.unsplash
elif [ "$1" == "--flush" ]; then
	rm -f $dir/*
else
	if [ -f ~/.unsplash ]; then
		arquivo=$(cat ~/.unsplash)
	fi
fi

if [ -f $arquivo ]; then
	if [ "$DESKTOP_SESSION" == "mate" ]; then 
   		gsettings set org.mate.background picture-filename "$arquivo"
	elif [ "$DESKTOP_SESSION" == "gnome" ]; then 
        gsettings set org.gnome.desktop.background picture-uri file://${arquivo}
	else
   		which feh >/dev/null 2>&1 && { feh --bg-fill "$arquivo"; }
    fi  
fi
