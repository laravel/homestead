#!/bin/sh

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