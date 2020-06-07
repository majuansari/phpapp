cd /code
echo "Laravel provisioning..."

dirs=( "/storage/public" "/storage/framework/cache" "/storage/framework/sessions" "/storage/framework/testing" "/storage/framework/views" "/storage/logs" )

for i in "${dirs[@]}"; do
    [ -d "$i" ] || mkdir -p $i
done

chmod -R 777 /storage
chmod -R 777 /public/storage
chown -R 9000:9000 /storage
chown -R 9000:9000 /public/storage

# move this to a different container
composer install 

php artisan migrate --force
php artisan clear-compiled
php artisan cache:clear
php artisan view:clear
php artisan route:clear
php artisan config:clear
