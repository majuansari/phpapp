#!/bin/sh
cd /code
echo "Laravel provisioning..."

dirs=( "/code/public/storage" "/code/storage/public" "/code/storage/framework/cache" "/code/storage/framework/sessions" "/code/storage/framework/testing" "/code/storage/framework/views" "/code/storage/logs" )

for i in "${dirs[@]}"; do
    [ -d "$i" ] || mkdir -p $i
done

chmod -R 777 /code/storage
chmod -R 777 /code/public/storage
chown -R 9000:9000 /code/storage
chown -R 9000:9000 /code/public/storage

# # move this to a different container
composer install 

php artisan migrate --force
php artisan clear-compiled
php artisan cache:clear
php artisan view:clear
php artisan route:clear
php artisan config:clear

echo "Sleep starting..."
 
sleep 300
echo "Sleep end..."
