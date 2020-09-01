#!/usr/bin/env bash
# 
# podmanctl.sh
#
# Criado em: 28-11-2019 23:50:39
# Alterado em: 28-11-2019 23:50:45

if [ -z $1 ]; then
	echo "Uso: $(basename $0) [start|stop|rm|rmi|upgrade|rebuild|podrm]"
	exit
fi

if [ "$1" == "stop" ]; then
    if [[ "$(podman ps -q)" ]]; then
	    podman ps -q | xargs podman stop
    fi
fi

if [ "$1" == "start" ]; then
    if [[ "$(podman ps -q -a)" ]]; then
	    podman ps -a -q | xargs podman start
    fi
fi

if [ "$1" == "rm" ]; then
    read -p "Tem certeza que deseja remover TODOS os containers? [s/N] " resp
    if [[ "$resp" == [sS]* ]]; then
        if [[ "$(podman ps -q)" ]]; then
            podman ps -q | xargs podman stop
            if [[ "$(podman ps -q -a)" ]]; then
                podman ps -a -q | xargs podman rm -v
            fi
        fi
    fi
fi

if [ "$1" == "podrm" ]; then
    read -p "Tem certeza que deseja remover TODOS os pods? [s/N] " resp
    if [[ "$resp" == [sS]* ]]; then
        if [[ "$(podman pod list -q)" ]]; then
            podman ps -q | xargs podman stop
            if [[ "$(podman pod list -q)" ]]; then
                podman pod list -q | xargs podman pod rm
            fi
        fi
    fi
fi

if [ "$1" == "rmi" ]; then
    read -p "Tem certeza que deseja remover TODAS as imagens? [s/N] " resp
    if [[ "$resp" == [sS]* ]]; then
        if [[ "$(podman ps -q -a)" ]]; then
            if [[ "$(podman ps -q)" ]]; then
                podman ps -q | xargs podman stop
            fi
            podman ps -a -q | xargs podman rm -v
        fi
        if [[ "$(podman images -q)" ]]; then
            podman images -q | xargs podman rmi
        fi
    fi
fi

if [ "$1" == "upgrade" ]; then
    if [[ "$(podman ps -q)" ]]; then
        podman ps -q | xargs podman stop
    fi
    if [[ "$(podman images -q)" ]]; then
        podman images | grep -v REPOSITORY | awk '{print $1}' | xargs -L1 podman pull 
    fi
    if [[ "$(podman ps -a -q)" ]]; then
        podman ps -a -q | xargs podman start
    fi
fi

if [ "$1" == "rebuild" ] || [ "$1" == "build" ]; then
    if [ -f docker-compose.yml ]; then
        podman-compose up -d --build
    else
        echo "Não existe um arquivo docker-compose.yml no diretório atual."
    fi
fi
