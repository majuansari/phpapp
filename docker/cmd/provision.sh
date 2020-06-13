#!/bin/bash
cd /codetemp || exit;
echo "Laravel provisioning...";


dirs=("/codetemp/public/storage" "/codetemp/storage/public" "/codetemp/storage/framework/cache" "/codetemp/storage/framework/sessions" "/codetemp/storage/framework/testing" "/codetemp/storage/framework/views" "/codetemp/storage/logs" )
for d in "${dirs[@]}"
do
    [ -d "$d" ] || mkdir -p $d
done


chmod -R 777 /codetemp/storage
chmod -R 777 /codetemp/public/storage
chown -R www-data:www-data /codetemp/storage
chown -R www-data:www-data /codetemp/public/storage
# # move this to a different container
composer install

php artisan migrate --force
php artisan clear-compiled
php artisan cache:clear
php artisan view:clear
php artisan route:clear
php artisan config:clear

