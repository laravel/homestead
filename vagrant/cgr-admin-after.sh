#!/bin/sh

sudo update-alternatives --set php /usr/bin/php7.3
sudo update-alternatives --set php-config /usr/bin/php-config7.3
sudo update-alternatives --set phpize /usr/bin/phpize7.3

if [ ! -d "app/storage" ]
then
  mkdir app/storage
  chmod -R 777 app/storage
  mkdir app/storage/cache
  mkdir app/storage/meta
  mkdir app/storage/views
  mkdir app/storage/sessions
fi

composer install --no-interaction
php artisan key:generate