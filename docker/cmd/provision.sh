#!/bin/bash
cd /src/pre-code || exit;
echo "Laravel provisioning...";


dirs=("/src/pre-code/public/storage" "/src/pre-code/storage/public" "/src/pre-code/storage/framework/cache" "/src/pre-code/storage/framework/sessions" "/src/pre-code/storage/framework/testing" "/src/pre-code/storage/framework/views" "/src/pre-code/storage/logs" )
for d in "${dirs[@]}"
do
    [ -d "$d" ] || mkdir -p $d
done


chown -R 9000:9000 /src/pre-code
chown -R 9000:9000 /src/pre-code/storage
chown -R 9000:9000 /src/pre-code/public/storage
chmod -R 777 /src/pre-code/storage
chmod -R 777 /src/pre-code/public/storage

ls -la /src/pre-code/storage/
# # move this to a different container
composer install

php artisan migrate --force
php artisan clear-compiled
php artisan cache:clear
php artisan view:clear
php artisan route:clear
php artisan config:clear

echo "copying code to shared volume"
cp -rp /src/pre-code/ /codeinit/

echo "checking the file permissions"
ls -la /codeinit/storage/
