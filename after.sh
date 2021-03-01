#!/bin/sh

#update NPM
npm install -g npm@latest

#install unrar to undo the RVTW database backup
sudo apt-get install unrar

cp -f /home/vagrant/homestead/vagrant/cgr-after.sh /home/vagrant/cgr/after.sh
cp -f /home/vagrant/homestead/vagrant/pm-after.sh /home/vagrant/platform-manager/after.sh
cp -f /home/vagrant/homestead/vagrant/rvtw-after.sh /home/vagrant/rvtw/after.sh
cp -f /home/vagrant/homestead/vagrant/cgr-admin-after.sh /home/vagrant/cgr-admin/after.sh

# composer install on CGR has a race condition in vagrant that is fixed
# by getting unzip to sleep - see https://github.com/composer/composer/issues/9627
sudo cp /home/vagrant/homestead/vagrant/unzip /usr/local/bin/unzip
sudo chmod +x /usr/local/bin/unzip

# Set command line PHP to 7.3
sudo update-alternatives --set php /usr/bin/php7.3
sudo update-alternatives --set php-config /usr/bin/php-config7.3
sudo update-alternatives --set phpize /usr/bin/phpize7.3

# Setup sphinx
# Create combined conf file from PM and CGR, place in ./vagrant
sudo apt-get --assume-yes install sphinxsearch
sudo cp /home/vagrant/homestead/vagrant/combo-sphinx.conf /etc/sphinxsearch/sphinx.conf
sudo sudo sed -i 's/START=no/START=yes/g' /etc/default/sphinxsearch
# Rotate sphinx and add to cron
line="*/5 * * * * /usr/bin/indexer --config /etc/sphinxsearch/sphinx.conf --rotate --all"
(sudo crontab -u root -l; echo "$line" ) | sudo crontab -u root -
sudo service sphinxsearch start
#sudo /usr/bin/indexer --config /etc/sphinxsearch/sphinx.conf --rotate --all

# This is for CGR Admin which requires mcrypt
sudo apt-get -y install gcc make autoconf libc-dev pkg-config
sudo apt-get -y install libmcrypt-dev
sudo pecl install mcrypt-1.0.2
sudo bash -c "echo extension=mcrypt.so > /etc/php/7.3/mods-available/mcrypt.ini"
sudo phpenmod -v 7.3 mcrypt
sudo service apache2 restart
sudo service php7.3-fpm restart