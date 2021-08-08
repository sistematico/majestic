#!/bin/sh
# bash < <(https://git.io/JR4RO)

DOCKER_PATH="$HOME/docker"
TEMP_PATH="/tmp/docker"
PROJECT_PATH="$HOME/github"
PROJECT_NAME="laravel"

[ ! -f /var/run/docker.sock ] && sudo systemctl start docker
[ ! -d $PROJECT_PATH ] && mkdir $PROJECT_PATH
[ -d $DOCKER_PATH ] && mv $DOCKER_PATH ~/.local/share/Trash/files/docker-$(date +%s)
[ ! -d $TEMP_PATH ] && git clone https://github.com/sistematico/majestic $TEMP_PATH

cd $TEMP_PATH && git pull
cp -a $TEMP_PATH/docker/docker $DOCKER_PATH

mkdir $DOCKER_PATH/certs/

if ! command -v mkcert &> /dev/null; then
    sudo curl -s -L https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64 > /usr/local/bin/mkcert
fi

cd $DOCKER_PATH/certs/ ; mkcert -install 1> /dev/null ; mkcert laravel 1> /dev/null

if ! command -v composer &> /dev/null; then
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    sudo mv composer.phar /usr/local/bin/composer
fi

[ -d $PROJECT_PATH/$PROJECT_NAME ] && mv $PROJECT_PATH/$PROJECT_NAME ~/.local/share/Trash/files/laravel-$(date +%s)

composer create-project laravel/laravel --prefer-dist $PROJECT_PATH/$PROJECT_NAME > /dev/null

if ! grep -Fxq "laravel" /etc/hosts 1> /dev/null 2> /dev/null
then
    sudo sed -i.bak '/127.0.0.1/s/$/ laravel/' /etc/hosts
fi

docker stop laravel-nginx laravel-php laravel-memcached laravel-redis laravel-mailhog laravel-mysql laravel-phpmyadmin laravel-mix 1> /dev/null
docker rm laravel-nginx laravel-php laravel-memcached laravel-redis laravel-mailhog laravel-mysql laravel-phpmyadmin laravel-mix 1> /dev/null

cd $DOCKER_PATH/compose/laravel ; docker-compose up -d --build

google-chrome-stable https://laravel