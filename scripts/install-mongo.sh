#!/usr/bin/env bash

if [ -f /home/vagrant/.mongo ]
then
    echo "MongoDB already installed."
    exit 0
fi

touch /home/vagrant/.mongo

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get -yq -o Dpkg::Options::="--force-confnew" install mongodb-org autoconf g++ make openssl libssl-dev libcurl4-openssl-dev pkg-config libsasl2-dev php-dev

sudo rm -rf /tmp/mongo-php-driver /usr/src/mongo-php-driver
git clone -c advice.detachedHead=false -q -b '1.2.9' --single-branch https://github.com/mongodb/mongo-php-driver.git /tmp/mongo-php-driver
sudo mv /tmp/mongo-php-driver /usr/src/mongo-php-driver
cd /usr/src/mongo-php-driver
git submodule -q update --init

phpize5.6
./configure --with-php-config=/usr/bin/php-config5.6 > /dev/null
make clean > /dev/null
make >/dev/null 2>&1
sudo make install
sudo chmod 644 /usr/lib/php/20131226/mongodb.so
sudo bash -c "echo 'extension=mongodb.so' > /etc/php/5.6/mods-available/mongo.ini"
sudo ln -s /etc/php/5.6/mods-available/mongo.ini /etc/php/5.6/cli/conf.d/20-mongo.ini
sudo ln -s /etc/php/5.6/mods-available/mongo.ini /etc/php/5.6/fpm/conf.d/20-mongo.ini
sudo service php5.6-fpm restart

phpize7.0
./configure --with-php-config=/usr/bin/php-config7.0 > /dev/null
make clean > /dev/null
make >/dev/null 2>&1
sudo make install
sudo chmod 644 /usr/lib/php/20151012/mongodb.so
sudo bash -c "echo 'extension=mongodb.so' > /etc/php/7.0/mods-available/mongo.ini"
sudo ln -s /etc/php/7.0/mods-available/mongo.ini /etc/php/7.0/cli/conf.d/20-mongo.ini
sudo ln -s /etc/php/7.0/mods-available/mongo.ini /etc/php/7.0/fpm/conf.d/20-mongo.ini
sudo service php7.0-fpm restart

phpize7.1
./configure --with-php-config=/usr/bin/php-config7.1 > /dev/null
make clean > /dev/null
make >/dev/null 2>&1
sudo make install
sudo chmod 644 /usr/lib/php/20160303/mongodb.so
sudo bash -c "echo 'extension=mongodb.so' > /etc/php/7.1/mods-available/mongo.ini"
sudo ln -s /etc/php/7.1/mods-available/mongo.ini /etc/php/7.1/cli/conf.d/20-mongo.ini
sudo ln -s /etc/php/7.1/mods-available/mongo.ini /etc/php/7.1/fpm/conf.d/20-mongo.ini
sudo service php7.1-fpm restart

sudo ufw allow 27017
sudo sed -i "s/bindIp: .*/bindIp: 0.0.0.0/" /etc/mongod.conf

sudo systemctl enable mongod
sudo systemctl start mongod
