#!/usr/bin/env bash
#
# Arquivo: dl.sh
#
# Cria uma lista.txt em /tmp
# Baixa todos os links contidos nesta lista usando o youtube-dl
# Apaga essa lista
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 08/01/2019 21:15:36
# Última alteração: 09/01/2019 05:16:36

[ -f ${HOME}/.config/user-dirs.dirs ] && . ${HOME}/.config/user-dirs.dirs

tipo="video"
icone="${HOME}/.local/share/icons/elementary/preferences-system-network.png"
pasta="${XDG_DESKTOP_DIR:-${HOME}/desk}" 	# Diretório para salvar os arquivos.
lixeira="${HOME}/.local/share/Trash"
url="$(xclip -o)"
som="complete" # /usr/share/sounds/freedesktop/stereo/
#lista="/tmp/lista.txt"
[ "$1" != "-dl" ] && readarray lista < /tmp/lista.txt

[ ! -d $pasta ] && mkdir -p $pasta

if [ "$1" == "-dl" ]; then
	cd $pasta
	dbus-launch notify-send -i $icone "Batch Downloader" "O download de $url foi iniciado."
	[ "$2" == "-a" ] && youtube-dl --extract-audio --audio-format mp3 "$url" || youtube-dl "$url"
	DISPLAY=:0 canberra-gtk-play -i $som 2>&1
	dbus-launch notify-send -i $icone "Batch Downloader" "Transfêrencias de $url finalizada."
elif [ "$1" == "-a" ]; then
	[[ ! -z "$url" ]] && echo $url >> /tmp/lista.txt
	DISPLAY=:0 canberra-gtk-play -i $som 2>&1
	dbus-launch notify-send -i $icone "Batch Downloader" "$url adicionada a /tmp/lista.txt"
elif [ "$1" == "-d" ]; then
	[ -f /tmp/lista.txt ] && rm /tmp/lista.txt
	DISPLAY=:0 canberra-gtk-play -i 'trash-empty' 2>&1
	dbus-launch notify-send -i $icone "Batch Downloader" "/tmp/lista.txt apagada."
elif [ "$1" == "-x" ]; then
	[ ! -f /tmp/lista.txt ] && exit 1
	cd $pasta
	dbus-launch notify-send -i $icone "Batch Downloader" "O download de $(cat /tmp/lista.txt | wc -l) ítens da /tmp/lista.txt foi iniciado."
	for i in "${lista[@]}"; do
		[ "$2" == "-a" ] && youtube-dl --extract-audio --audio-format mp3 $i || youtube-dl $i
		DISPLAY=:0 canberra-gtk-play -i $som 2>&1
		dbus-launch notify-send -i $icone "Batch Downloader" "Transfêrencias de $i finalizada."
	done
	DISPLAY=:0 canberra-gtk-play -i $som 2>&1
	dbus-launch notify-send -i $icone "Batch Downloader" "Todas as transfêrencias de /tmp/lista.txt foram finalizadas."
	echo '-----------------------' >> /tmp/batchdownloader.log
	cat /tmp/lista.txt >> /tmp/batchdownloader.log
	echo '-----------------------' >> /tmp/batchdownloader.log
	rm /tmp/lista.txt
fi
