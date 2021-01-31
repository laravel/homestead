#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/mongodb ]
then
    echo "MongoDB already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/mongodb
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confnew" install mongodb-org autoconf g++ make openssl libssl-dev libcurl4-openssl-dev pkg-config libsasl2-dev php-dev

sudo ufw allow 27017
sudo sed -i "s/bindIp: .*/bindIp: 0.0.0.0/" /etc/mongod.conf

sudo systemctl enable mongod
sudo systemctl start mongod

sudo rm -rf /tmp/mongo-php-driver /usr/src/mongo-php-driver
git clone -c advice.detachedHead=false -q -b '1.9.0' --single-branch https://github.com/mongodb/mongo-php-driver.git /tmp/mongo-php-driver
sudo mv /tmp/mongo-php-driver /usr/src/mongo-php-driver
cd /usr/src/mongo-php-driver
git submodule -q update --init

sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confold" install php5.6-dev
phpize5.6
./configure --with-php-config=/usr/bin/php-config5.6 > /dev/null
make clean > /dev/null
make >/dev/null 2>&1
sudo make install
sudo bash -c "echo 'extension=mongodb.so' > /etc/php/5.6/mods-available/mongo.ini"
sudo ln -s /etc/php/5.6/mods-available/mongo.ini /etc/php/5.6/cli/conf.d/20-mongo.ini
sudo ln -s /etc/php/5.6/mods-available/mongo.ini /etc/php/5.6/fpm/conf.d/20-mongo.ini
sudo service php5.6-fpm restart

sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confold" install php7.0-dev
phpize7.0
./configure --with-php-config=/usr/bin/php-config7.0 > /dev/null
make clean > /dev/null
make >/dev/null 2>&1
sudo make install
sudo bash -c "echo 'extension=mongodb.so' > /etc/php/7.0/mods-available/mongo.ini"
sudo ln -s /etc/php/7.0/mods-available/mongo.ini /etc/php/7.0/cli/conf.d/20-mongo.ini
sudo ln -s /etc/php/7.0/mods-available/mongo.ini /etc/php/7.0/fpm/conf.d/20-mongo.ini
sudo service php7.0-fpm restart

sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confold" install php7.1-dev
phpize7.1
./configure --with-php-config=/usr/bin/php-config7.1 > /dev/null
make clean > /dev/null
make >/dev/null 2>&1
sudo make install
sudo bash -c "echo 'extension=mongodb.so' > /etc/php/7.1/mods-available/mongo.ini"
sudo ln -s /etc/php/7.1/mods-available/mongo.ini /etc/php/7.1/cli/conf.d/20-mongo.ini
sudo ln -s /etc/php/7.1/mods-available/mongo.ini /etc/php/7.1/fpm/conf.d/20-mongo.ini
sudo service php7.1-fpm restart

phpize7.2
./configure --with-php-config=/usr/bin/php-config7.2 > /dev/null
make clean > /dev/null
make >/dev/null 2>&1
sudo make install
sudo bash -c "echo 'extension=mongodb.so' > /etc/php/7.2/mods-available/mongo.ini"
sudo ln -s /etc/php/7.2/mods-available/mongo.ini /etc/php/7.2/cli/conf.d/20-mongo.ini
sudo ln -s /etc/php/7.2/mods-available/mongo.ini /etc/php/7.2/fpm/conf.d/20-mongo.ini
sudo service php7.2-fpm restart

phpize7.3
./configure --with-php-config=/usr/bin/php-config7.3 > /dev/null
make clean > /dev/null
make >/dev/null 2>&1
sudo make install
sudo bash -c "echo 'extension=mongodb.so' > /etc/php/7.3/mods-available/mongo.ini"
sudo ln -s /etc/php/7.3/mods-available/mongo.ini /etc/php/7.3/cli/conf.d/20-mongo.ini
sudo ln -s /etc/php/7.3/mods-available/mongo.ini /etc/php/7.3/fpm/conf.d/20-mongo.ini
sudo service php7.3-fpm restart

phpize7.4
./configure --with-php-config=/usr/bin/php-config7.4 > /dev/null
make clean > /dev/null
make >/dev/null 2>&1
sudo make install
sudo bash -c "echo 'extension=mongodb.so' > /etc/php/7.4/mods-available/mongo.ini"
sudo ln -s /etc/php/7.4/mods-available/mongo.ini /etc/php/7.4/cli/conf.d/20-mongo.ini
sudo ln -s /etc/php/7.4/mods-available/mongo.ini /etc/php/7.4/fpm/conf.d/20-mongo.ini
sudo service php7.4-fpm restart

phpize8.0
./configure --with-php-config=/usr/bin/php-config8.0 > /dev/null
make clean > /dev/null
make >/dev/null 2>&1
sudo make install
sudo bash -c "echo 'extension=mongodb.so' > /etc/php/8.0/mods-available/mongo.ini"
sudo ln -s /etc/php/8.0/mods-available/mongo.ini /etc/php/8.0/cli/conf.d/20-mongo.ini
sudo ln -s /etc/php/8.0/mods-available/mongo.ini /etc/php/8.0/fpm/conf.d/20-mongo.ini
sudo service php8.0-fpm restart

mongo admin --eval "db.createUser({user:'homestead',pwd:'secret',roles:['root']})"
