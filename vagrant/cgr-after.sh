#!/bin/sh

if [ -d "cgr" ]
then
  cd cgr
fi

# Set command line to PHP 7.3
sudo update-alternatives --set php /usr/bin/php7.3
sudo update-alternatives --set php-config /usr/bin/php-config7.3
sudo update-alternatives --set phpize /usr/bin/phpize7.3

composer install --no-interaction


# Make this import go A LOT faster (still takes awhile, even on SSD)
bash vagrant/mysql-faster-imports.sh
mysql -uroot -psecret cgr < /home/vagrant/cgr/database/seeds/rvpr.sql
mysql -uroot -psecret cgr < /home/vagrant/cgr/database/seeds/rvprmissing.sql

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

# Setup Laravel stuff
php artisan migrate
php artisan key:generate
php artisan storage:link

yarn install
yarn run dev
# Build NPM
# npm run dev
# --- Build NPM on the host side