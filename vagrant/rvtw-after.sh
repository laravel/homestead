#!/bin/sh

sudo update-alternatives --set php /usr/bin/php7.3
sudo update-alternatives --set php-config /usr/bin/php-config7.3
sudo update-alternatives --set phpize /usr/bin/phpize7.3

if [ ! -f "backend/.env" ]
then
  cp backend/.env.homestead backend/.env
fi

bash ./backend/mysql-faster-imports.sh
mysql -uroot -psecret rvtw < /home/vagrant/rvtw/backend/database/seeds/rvtrip.sql

cd backend
composer install --no-interaction

php artisan migrate
php artisan key:generate
php artisan storage:link

cd ../frontend
yarn install
yarn build-dev