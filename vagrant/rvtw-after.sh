#!/bin/sh

sudo update-alternatives --set php /usr/bin/php7.3
sudo update-alternatives --set php-config /usr/bin/php-config7.3
sudo update-alternatives --set phpize /usr/bin/phpize7.3

if [ ! -f "backend/.env" ]
then
  cp backend/.env.homestead backend/.env
fi

dos2unix ./backend/mysql-faster-imports.sh
bash ./backend/mysql-faster-imports.sh
cd /home/vagrant/rvtw/backend/database/seeds
unrar e /home/vagrant/rvtw/backend/database/seeds/rvtrip.rar
cd /home/vagrant/rvtw
mysql -uroot -psecret rvtw < /home/vagrant/rvtw/backend/database/seeds/rvtrip.sql
rm -f /home/vagrant/rvtw/backend/database/seeds/rvtrip.sql

cd backend
composer install --no-interaction
sudo yarn install
yarn run dev

php artisan migrate
php artisan key:generate
php artisan storage:link

cd ../frontend
dos2unix build*.sh
yarn install
yarn build-dev
