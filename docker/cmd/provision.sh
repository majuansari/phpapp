#!/bin/bash
cd /pre-code || exit;
echo "Laravel provisioning...";


dirs=("/pre-code/public/storage" "/pre-code/storage/public" "/pre-code/storage/framework/cache" "/pre-code/storage/framework/sessions" "/pre-code/storage/framework/testing" "/pre-code/storage/framework/views" "/pre-code/storage/logs" )
for d in "${dirs[@]}"
do
    [ -d "$d" ] || mkdir -p $d
done


chmod -R 777 /pre-code/storage
chmod -R 777 /pre-code/public/storage
chown -R www-data:www-data /pre-code/storage
chown -R www-data:www-data /pre-code/public/storage
# # move this to a different container
composer install

php artisan migrate --force
php artisan clear-compiled
php artisan cache:clear
php artisan view:clear
php artisan route:clear
php artisan config:clear

cp -rp /pre-code/ /codetemp/