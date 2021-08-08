#!/bin/sh
# https://git.io/JR4RO

[ ! -f /var/run/docker.sock ] && sudo systemctl start docker
[ -d ~/newdocker ] && rm -rf ~/newdocker

git clone https://github.com/sistematico/majestic ~/newdocker
find ~/newdocker -type d -not -name 'docker' -delete

mkdir ~/newdocker/certs/

if ! command -v mkcert &> /dev/null
then
    sudo curl -s -L https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64 > /usr/local/bin/mkcert
    exit
fi

if [ ! -f cd ~/newdocker/certs/laravel.pem ]; then
    cd ~/newdocker/certs/
    mkcert -install
    mkcert laravel
fi

cd ~/newdocker/compose/laravel

if ! grep -Fxq "laravel" /etc/hosts
then
    sudo sed '/127.0.0.1/s/$/ laravel/' /etc/hosts
fi

docker stop laravel-nginx laravel-php laravel-memcached laravel-redis laravel-mailhog laravel-mysql laravel-phpmyadmin laravel-mix
docker rm laravel-nginx laravel-php laravel-memcached laravel-redis laravel-mailhog laravel-mysql laravel-phpmyadmin laravel-mix

docker-compose up -d --build

google-chrome-stable https://laravel