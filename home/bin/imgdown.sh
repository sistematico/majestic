#!/bin/bash
##############################################################################
#                                
# imgdown.sh
#                                
# Autor: Lucas Saliés Brum a.k.a. sistematico <lucas@archlinux.com.br> 
#
# Criado em: 16-03-2018 16:35:20
# Modificado em: 10-12-2019 00:15:41
#
# Este trabalho está licenciado com uma Licença Creative Commons
# Atribuição 4.0 Internacional
# http://creativecommons.org/licenses/by/4.0/
#
# https://gist.github.com/tayfie/6dad43f1a452440fba7ea1c06d1b603a
##############################################################################


ext="jpg"  		# Separadas por virgula.
pasta="$(pwd)" 	# Diretório para salvar os arquivos.
min='300' 		# Em pixels verticais
lixeira="${HOME}/.local/share/Trash"
pasta="${HOME}/desk/$$"
turl="$(xclip -o)"
icone="${HOME}/.local/share/icons/elementary/camera-photo.png"
som='complete'

padrao='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [[ ! ${turl} =~ $padrao ]]; then
	notify-send -i $icone "Video Downloader" "O link é inválido!"
    exit
fi


if [ ! -f $pasta ]; then
	mkdir -p $pasta
else
	exit
fi

dominio=$(echo "$turl" | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/" | sed "s/^www\.//")
wget --quiet -P "$pasta" -nd -r -l 1 -H -D $dominio -A $ext "$turl"

for a in $pasta/*.$ext; do
	if [[ $(convert $a -print "%h" /dev/null) -lt $min ]]; then
		mv $a $lixeira
	fi
done

rm -rf $pasta/robots.txt*

notify-send -i $icone "IMGdown" "Transferencia de $$ finalizada."
canberra-gtk-play -i $som
