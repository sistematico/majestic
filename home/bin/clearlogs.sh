#!/usr/bin/env sh
#
# Arquivo: clearlogs.sh
#
# Feito por Lucas Saliés Brum a.k.a. sistematico, <lucas@archlinux.com.br>
#
# Criado em: 18/09/2021 15:48:06
# Última alteração: 18/09/2021 15:48:10

if [ $UID = 0 ]; then
	journalctl --flush --rotate
	journalctl --vacuum-size=1K
	journalctl --verify
else
	if sudo true; then
    	sudo journalctl --flush --rotate
    	sudo journalctl --vacuum-size=1K
    	sudo journalctl --verify
	else
		echo "Necessita de permissões de super-usuário."
	fi
fi
