#!/bin/sh

sudo update-alternatives --set php /usr/bin/php7.3
sudo update-alternatives --set php-config /usr/bin/php-config7.3
sudo update-alternatives --set phpize /usr/bin/phpize7.3

if [ ! -f ".env" ]
then
  cp .env.example .env
fi

mysql -uroot -psecret -e "CREATE DATABASE IF NOT EXISTS test"
mysql -uroot -psecret platform_manager < /home/vagrant/platform-manager/database/seeds/sso.sql

#update PM user with existing user email / password for this user is 123456
# dnjhj@hjh.com is a user in PM
# kenf1111@hotmail.com is a user IN CGR.
mysql -uroot -psecret -e "UPDATE platform_manager.users SET email = 'kenf1111@hotmail.com' WHERE email = 'dnjhj@hjh.com'"
# Set support email for the RVTW client so new sign up works
mysql -uroot -psecret -e "UPDATE platform_manager.oauth_clients SET client_site_contact_email = 'support@rvlife.com' WHERE id = 3"

composer install --no-interaction
#yarn install
#npm i
#npm run dev

if [ ! -f ".env" ]
then
  cp .env.example .env
fi

if [ ! -f ".env.testing" ]
then
  cp .env.testing.example .env.testing
fi

php artisan migrate
php artisan key:generate
php artisan storage:link
php artisan passport:keys
php artisan passport:client --personal

#yarn run dev

#cd ../nova-components/StripeProductManage
#npm i
#npm run dev
#yarn install
#yarn run dev
