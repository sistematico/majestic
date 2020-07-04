#!/usr/bin/env bash
# 
# dockerctl.sh
#
# Criado em: 28-11-2019 23:50:39
# Alterado em: 28-11-2019 23:50:45

if [ ! $1 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo "Uso: $(basename $0) [start|stop|rm|rmi|upgrade|rebuild]"
	exit 0
fi

if [ "$1" == "stop" ]; then
    if [[ "$(docker ps -q)" ]]; then
	    docker ps -q | xargs docker stop
    fi
fi

if [ "$1" == "start" ]; then
    if [[ "$(docker ps -q -a)" ]]; then
	    docker ps -a -q | xargs docker start
    fi
fi

if [ "$1" == "rm" ]; then
    read -p "Tem certeza que deseja remover TODOS os containers? [s/N] " resp
    if [[ "$resp" == [sS]* ]]; then
        if [[ "$(docker ps -q)" ]]; then
            docker ps -q | xargs docker stop
            if [[ "$(docker ps -q -a)" ]]; then
                docker ps -a -q | xargs docker rm -v
            fi
        fi
    fi
fi

if [ "$1" == "rmi" ]; then
    read -p "Tem certeza que deseja remover TODAS as imagens? [s/N] " resp
    if [[ "$resp" == [sS]* ]]; then
        if [[ "$(docker ps -q -a)" ]]; then
            if [[ "$(docker ps -q)" ]]; then
                docker ps -q | xargs docker stop
            fi
            docker ps -a -q | xargs docker rm -v
        fi
        if [[ "$(docker images -q)" ]]; then
            docker images -q | xargs docker rmi
        fi
    fi
fi

if [ "$1" == "upgrade" ]; then
    if [[ "$(docker ps -q)" ]]; then
        docker ps -q | xargs docker stop
    fi
    if [[ "$(docker images -q)" ]]; then
        docker images | grep -v REPOSITORY | awk '{print $1}' | xargs -L1 docker pull 
    fi
    if [[ "$(docker ps -a -q)" ]]; then
        docker ps -a -q | xargs docker start
    fi
fi

if [ "$1" == "rebuild" ] || [ "$1" == "build" ]; then
    if [ -f docker-compose.yml ]; then
        docker-compose up -d --build
    else
        echo "Não existe um arquivo docker-compose.yml no diretório atual."
    fi
fi
