#!/bin/sh

if [ -d "platform-manager" ]
then
  cd platform-manager
fi

mysql -uroot -psecret -e "CREATE DATABASE IF NOT EXISTS test"
mysql -uroot -psecret platform_manager < /home/vagrant/platform-manager/database/seeds/sso.sql

composer install --no-interaction
yarn install

sudo update-alternatives --set php /usr/bin/php7.3
sudo update-alternatives --set php-config /usr/bin/php-config7.3
sudo update-alternatives --set phpize /usr/bin/phpize7.3

if [ ! -f ".env" ]
then
  cp .env.example .env
fi

if [ ! -f ".env.testing" ]
then
  cp .env.testing.example .env.testing
fi

# Install Sphinx - if this is executed from the combo homestead box then sphinx will
# have already been setup
if [ ! -f "/etc/sphinxsearch/sphinx.conf" ]
then
  sudo apt-get --assume-yes install sphinxsearch
  sudo cp vagrant/sphinx.conf /etc/sphinxsearch/sphinx.conf
  sudo sudo sed -i 's/START=no/START=yes/g' /etc/default/sphinxsearch
  # Rotate sphinx and add to cron
  line="*/5 * * * * /usr/bin/indexer --config /etc/sphinxsearch/sphinx.conf --rotate --all"
  (sudo crontab -u root -l; echo "$line" ) | sudo crontab -u root -
  sudo service sphinxsearch start
  sudo /usr/bin/indexer --config /etc/sphinxsearch/sphinx.conf --rotate --all
fi

php artisan migrate
php artisan key:generate
php artisan storage:link
php artisan passport:keys
php artisan passport:client --personal

yarn run dev

cd ../nova-components/StripeProductManage
yarn install
yarn run dev
