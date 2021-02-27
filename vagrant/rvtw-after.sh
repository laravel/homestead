#!/bin/sh

if [ ! -f "backend/.env" ]
then
  cp backend/.env.homestead backend/.env
fi

bash ./backend/mysql-faster-imports.sh
mysql -uroot -psecret rvtw < /home/vagrant/rvtw/backend/database/seeds/rvtrip.sql

cd backend
composer install --no-interaction
yarn install
yarn run dev

php artisan migrate
php artisan key:generate
php artisan storage:link

cd ../frontend
yarn install
yarn build-dev