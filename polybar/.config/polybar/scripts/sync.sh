#!/usr/bin/env bash

backup=0
editor="subl"
user="nginx"
host="hera"
local="${HOME}/htdocs"
remoto="/var/www"
config="${HOME}/.config/polybar/configs/sync.conf"
iconeOK="${HOME}/.local/share/icons/elementary/preferences-system-network.png"
iconeERRO="${HOME}/.local/share/icons/elementary/network-error.png"
excluir=('sftp-config.json' 'sentry/' 'cabron/')

if [ ${#excluir[@]} -gt 0 ]; then
	for i in ${excluir[@]}; do
		excl+="--exclude=\'$i\' "
	done
fi

largura() {
	set "$(printf '...%s\b\b...\n' "$1" | col -b)"
	echo "$((${#1} - 4))"
}

sync() {

	if [ $backup == 1 ]; then
		rsync -avzq ${user}@${host}:${remoto}/$1/ /tmp/$1-$(date +"%T")
	fi

	status=0
	rsync -avzq --delete ${local}/$1/ ${user}@${host}:${remoto}/$1/ $excl || status=$?
	if (($status != 0)); then
		dbus-launch notify-send -i $iconeERRO "WebSite Sync" "Erro ao atualizar <b>$1</b>\nCódigo: ${status}"
	else
		dbus-launch notify-send -i $iconeOK "WebSite Sync" "Site <b>$1</b> atualizado.\nExclude: $excl"
	fi
}

if [[ "${1}" == "-c" ]]; then
	$editor $config
elif [[ "${1}" == "-u" ]]; then
	if [ -f $config ]; then
		config=$(cat $config)
		while IFS= read -r site; do
			titulo="Atualizar o site ${site}?"
			#l=$(largura "$titulo")
			l=$(echo $titulo | wc -c)
	    	confirma=$(echo -e "Sim\nNão" | rofi -p "$titulo" -dmenu -bw 0 -lines 2 -separator-style none -location 0 -width $(($l-15)) -hide-scrollbar -padding 5)
	    	if [ "$confirma" == "Sim" ]; then
	    		sync $site
	    	else
	    		dbus-launch notify-send -i $iconeERRO "WebSite Sync" "Atualização de <b>$site</b> cancelada."
	    	fi
		done <<< "$config"
	fi
fi

echo ""