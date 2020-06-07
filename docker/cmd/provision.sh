#!/bin/sh
cd /codetemp
echo "Laravel provisioning..."

dirs=( "/codetemp/public/storage" "/codetemp/storage/public" "/codetemp/storage/framework/cache" "/codetemp/storage/framework/sessions" "/codetemp/storage/framework/testing" "/codetemp/storage/framework/views" "/codetemp/storage/logs" )

for i in "${dirs[@]}"; do
    [ -d "$i" ] || mkdir -p $i
done

chmod -R 777 /codetemp/storage
chmod -R 777 /codetemp/public/storage
chown -R 9000:9000 /codetemp/storage
chown -R 9000:9000 /codetemp/public/storage

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
