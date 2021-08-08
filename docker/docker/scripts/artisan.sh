#!/bin/sh
set -e

composer install
php artisan migrate