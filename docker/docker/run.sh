#!/bin/sh
# bash < <(curl -s -L https://git.io/JR4RO?v=1)

DOCKER_PATH="$HOME/docker"
TEMP_PATH="/tmp/docker"
PROJECT_PATH="$HOME/github"
PROJECT_NAME="laravel"

function progress() {
    pid=$!; spin='-\|/'; i=0

    reset='\e[0m'; black=30; red=31; green=32; yellow=33; blue=34; magenta=35; cyan=36; white=37

    case $2 in
        hello)
            echo "Hello yourself!"
            ;;
        bye)
            echo "See you again!"
            break
            ;;
        *)
            cor='\e[0m'
            ;;
    esac


    while kill -0 $pid 2>/dev/null
    do
        i=$(( (i+1) %4 ))
        # echo -ne "\r\e[1;31m[\e[1;32m${spin:$i:1}\e[1;31m] \e[1;33m$1 \e[0m"
        #printf "\r [${spin:$i:1}] $1"
        printf "\r\e[1;31m[\e[1;32m ${spin:$i:1} \e[1;31m] \e[1;33m$1 \e[0m"
        sleep .1
    done
}

[ ! -f /var/run/docker.sock ] && sudo systemctl start docker
[ ! -d $PROJECT_PATH ] && mkdir $PROJECT_PATH
[ -d $DOCKER_PATH ] && mv $DOCKER_PATH ~/.local/share/Trash/files/docker-$(date +%s)
[ ! -d $TEMP_PATH ] && git clone https://github.com/sistematico/majestic $TEMP_PATH

cd $TEMP_PATH && git pull > /dev/null &
progress "Efetuando o pull"

cp -a $TEMP_PATH/docker/docker $DOCKER_PATH

mkdir $DOCKER_PATH/certs/

if ! command -v mkcert 1> /dev/null 2> /dev/null
then
    sudo curl -s -L https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64 > /usr/local/bin/mkcert
fi

cd $DOCKER_PATH/certs/ 
mkcert -install > /dev/null 2> /dev/null
mkcert laravel > /dev/null 2> /dev/null

if ! command -v composer &> /dev/null; then
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    sudo mv composer.phar /usr/local/bin/composer
fi

[ -d $PROJECT_PATH/$PROJECT_NAME ] && mv $PROJECT_PATH/$PROJECT_NAME ~/.local/share/Trash/files/laravel-$(date +%s)

composer create-project laravel/laravel --prefer-dist $PROJECT_PATH/$PROJECT_NAME 2> /dev/null > /dev/null &
progress "Criando o projeto..."

if grep -Fxq "$PROJECT_NAME" /etc/hosts 2> /dev/null;
then
    sudo sed -i.bak "s|127.0.0.1|$ $PROJECT_NAME|g" /etc/hosts
fi

# docker stop laravel-nginx laravel-php laravel-memcached laravel-redis laravel-mailhog laravel-mysql laravel-phpmyadmin laravel-mix 1> /dev/null 2> /dev/null &
docker stop $(docker ps -a -q) 2> /dev/null > /dev/null &
progress "Parando containers..."

#docker rm laravel-nginx laravel-php laravel-memcached laravel-redis laravel-mailhog laravel-mysql laravel-phpmyadmin laravel-mix 1> /dev/null 2> /dev/null &
docker rm $(docker ps -a -q) 2> /dev/null > /dev/null &
progress "Removendo containers..."

cd $DOCKER_PATH/compose/laravel 

#docker-compose up -d --build > /dev/null 2> /dev/null &
docker-compose up -d --build
progress "Configurando o Docker..."

echo

google-chrome-stable https://laravel