#!/bin/sh
# https://git.io/JR4RO

[ ! -f /var/run/docker.sock ] && sudo systemctl start docker
[ -d ~/newdocker ] && mv ~/newdocker ~/.local/share/Trash/files/newdocker-$(date +%s)
[ -d ~/github ] && mkdir ~/github

if [ ! -d /tmp/newdocker ]; then
    git clone https://github.com/sistematico/majestic /tmp/newdocker
fi

cd /tmp/newdocker
git pull

cp -a /tmp/newdocker/docker/docker ~/newdocker
mkdir ~/newdocker/certs/

if ! command -v mkcert &> /dev/null; then
    sudo curl -s -L https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64 > /usr/local/bin/mkcert
    exit
fi

if [ ! -f cd ~/newdocker/certs/laravel.pem ]; then
    cd ~/newdocker/certs/
    mkcert -install
    mkcert laravel
fi

if ! command -v composer &> /dev/null; then
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    sudo mv composer.phar /usr/local/bin/composer
fi

[ -d ~/github/laravel ] && mv ~/github/laravel ~/.local/share/Trash/files/laravel-$(date +%s)
composer create-project laravel/laravel --prefer-dist ~/github/laravel

if ! grep -Fxq "laravel" /etc/hosts > /dev/null
then
    sudo sed '/127.0.0.1/s/$/ laravel/' /etc/hosts
fi

docker stop laravel-nginx laravel-php laravel-memcached laravel-redis laravel-mailhog laravel-mysql laravel-phpmyadmin laravel-mix > /dev/null
docker rm laravel-nginx laravel-php laravel-memcached laravel-redis laravel-mailhog laravel-mysql laravel-phpmyadmin laravel-mix > /dev/null

docker-compose up -d --build

google-chrome-stable https://laravel