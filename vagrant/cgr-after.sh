#!/bin/sh

sudo update-alternatives --set php /usr/bin/php7.3
sudo update-alternatives --set php-config /usr/bin/php-config7.3
sudo update-alternatives --set phpize /usr/bin/phpize7.3

if [ ! -f ".env" ]
then
  cp .env.homestead .env
fi

if [ ! -f "cypress.env.json" ]
then
    cp cypress.env.json.example cypress.env.json
fi

# Set command line to PHP 7.3
composer install --no-interaction

# Make this import go A LOT faster (still takes awhile, even on SSD)
dos2unix vagrant/mysql-faster-imports.sh
bash vagrant/mysql-faster-imports.sh
mysql -uroot -psecret rvparkreviews < /home/vagrant/cgr/database/seeds/rvpr.sql
mysql -uroot -psecret rvparkreviews < /home/vagrant/cgr/database/seeds/rvprmissing.sql

# Setup Laravel stuff
php artisan migrate
php artisan key:generate
php artisan storage:link

#npm install
#npm run dev
# Build NPM
