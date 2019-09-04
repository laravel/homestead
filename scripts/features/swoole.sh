#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.homestead-features/swoole ]
then
    echo "Swoole already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/swoole
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

sudo rm -rf /tmp/swoole-php-driver /usr/src/swoole-php-driver
git clone -c advice.detachedHead=false -q -b 'v4.4.5' --single-branch https://github.com/swoole/swoole-src.git /tmp/swoole-php-driver
sudo mv /tmp/swoole-php-driver /usr/src/swoole-php-driver
cd /usr/src/swoole-php-driver
git submodule -q update --init

sudo DEBIAN_FRONTEND=noninteractive apt-get -y install php7.1-dev
phpize7.1
./configure --enable-sockets --with-php-config=/usr/bin/php-config7.1 > /dev/null
make clean > /dev/null
make >/dev/null 2>&1
sudo make install
sudo bash -c "echo 'extension=swoole.so' > /etc/php/7.1/mods-available/swoole.ini"
sudo ln -s /etc/php/7.1/mods-available/swoole.ini /etc/php/7.1/cli/conf.d/20-swoole.ini
sudo ln -s /etc/php/7.1/mods-available/swoole.ini /etc/php/7.1/fpm/conf.d/20-swoole.ini
sudo service php7.1-fpm restart

sudo DEBIAN_FRONTEND=noninteractive apt-get -y install php7.2-dev
phpize7.2
./configure --enable-sockets --with-php-config=/usr/bin/php-config7.2 > /dev/null
make clean > /dev/null
make >/dev/null 2>&1
sudo make install
sudo bash -c "echo 'extension=swoole.so' > /etc/php/7.2/mods-available/swoole.ini"
sudo ln -s /etc/php/7.2/mods-available/swoole.ini /etc/php/7.2/cli/conf.d/20-swoole.ini
sudo ln -s /etc/php/7.2/mods-available/swoole.ini /etc/php/7.2/fpm/conf.d/20-swoole.ini
sudo service php7.2-fpm restart

sudo DEBIAN_FRONTEND=noninteractive apt-get -y install php7.3-dev
phpize7.3
./configure --enable-sockets --with-php-config=/usr/bin/php-config7.3 > /dev/null
make clean > /dev/null
make >/dev/null 2>&1
sudo make install
sudo bash -c "echo 'extension=swoole.so' > /etc/php/7.3/mods-available/swoole.ini"
sudo ln -s /etc/php/7.3/mods-available/swoole.ini /etc/php/7.3/cli/conf.d/20-swoole.ini
sudo ln -s /etc/php/7.3/mods-available/swoole.ini /etc/php/7.3/fpm/conf.d/20-swoole.ini
sudo service php7.3-fpm restart
