#!/usr/bin/env bash
#
# FG: reset = 0, black = 30, red = 31, green = 32, yellow = 33, blue = 34, magenta = 35, cyan = 36, white = 37
# BG: reset = 0, black = 40, red = 41, green = 42, yellow = 43, blue = 44, magenta = 45, cyan = 46, white=47

REGEX="^[a-zA-Z0-9.-]+$"

if ! command -v dialog &> /dev/null
then
    echo -e "O programa \e[1;31mdialog\e[0m não está instalado, instale-o primeiro."
    exit
fi

if [ ! $1 ]; then
    DIR=$(dialog --stdout --inputbox 'Digite o nome do projeto:' 0 0 "breeze-bootstrap")
else 
    DIR="$1"
fi

[ -z "$DIR" ] && exit

if [ -d "$DIR" ]; then
    dialog --yesno "O diretório $DIR jś existe, deseja sobre-escrever?" 0 0

    if [ $? = 0 ]; then
        echo "Agora são: $( date )"
    else
        echo 'Ok, não vou mostrar as horas.'
    fi
fi

if [[ ! "$DIR" =~ $REGEX ]]; then
  echo -e "O caminho \e[1;31m${DIR}\e[0m é inválido."
  exit
fi

composer create-project laravel/laravel $DIR
cd $DIR
composer require sistematico/bootstrap-breeze --dev
php artisan breeze:install vue-bootstrap
npm install
npm run dev
php artisan migrate