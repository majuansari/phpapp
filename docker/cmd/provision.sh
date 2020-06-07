#!/bin/sh
cd /codetemp || exit;
echo "Laravel provisioning...";

# # move this to a different container
composer install

php artisan migrate --force
php artisan clear-compiled
php artisan cache:clear
php artisan view:clear
php artisan route:clear
php artisan config:clear

