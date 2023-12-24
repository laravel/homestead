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

ARCH=$(arch)

touch /home/$WSL_USER_NAME/.homestead-features/mongodb
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

if [[ "$ARCH" == "aarch64" ]]; then
  echo "deb [ arch=arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/$1 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-"$1".list
else
  echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/$1 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-"$1".list
fi

curl -fsSL https://pgp.mongodb.com/server-$1.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-$1.gpg --dearmor
sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confnew" install mongodb-org autoconf g++ make openssl libssl-dev libcurl4-openssl-dev pkg-config libsasl2-dev php-dev

sudo ufw allow 27017
sudo sed -i "s/bindIp: .*/bindIp: 0.0.0.0/" /etc/mongod.conf

sudo systemctl enable mongod
sudo systemctl start mongod

sudo rm -rf /tmp/mongo-php-driver /usr/src/mongo-php-driver
git clone -c advice.detachedHead=false -q -b '1.16.2' --single-branch https://github.com/mongodb/mongo-php-driver.git /tmp/mongo-php-driver
sudo mv /tmp/mongo-php-driver /usr/src/mongo-php-driver
cd /usr/src/mongo-php-driver
git submodule -q update --init

if [ -f /home/$WSL_USER_NAME/.homestead-features/php81 ]
then
    phpize8.1
    ./configure --with-php-config=/usr/bin/php-config8.1 > /dev/null
    make clean > /dev/null
    make >/dev/null 2>&1
    sudo make install
    sudo bash -c "echo 'extension=mongodb.so' > /etc/php/8.1/mods-available/mongo.ini"
    sudo ln -s /etc/php/8.1/mods-available/mongo.ini /etc/php/8.1/cli/conf.d/20-mongo.ini
    sudo ln -s /etc/php/8.1/mods-available/mongo.ini /etc/php/8.1/fpm/conf.d/20-mongo.ini
    sudo service php8.1-fpm restart
fi

if [ -f /home/$WSL_USER_NAME/.homestead-features/php81 ]
then
    phpize8.2
    ./configure --with-php-config=/usr/bin/php-config8.2 > /dev/null
    make clean > /dev/null
    make >/dev/null 2>&1
    sudo make install
    sudo bash -c "echo 'extension=mongodb.so' > /etc/php/8.2/mods-available/mongo.ini"
    sudo ln -s /etc/php/8.2/mods-available/mongo.ini /etc/php/8.2/cli/conf.d/20-mongo.ini
    sudo ln -s /etc/php/8.2/mods-available/mongo.ini /etc/php/8.2/fpm/conf.d/20-mongo.ini
    sudo service php8.2-fpm restart
fi

phpize"$2"
./configure --with-php-config=/usr/bin/php-config"$2" > /dev/null
make clean > /dev/null
make >/dev/null 2>&1
sudo make install
sudo bash -c "echo 'extension=mongodb.so' > /etc/php/$2/mods-available/mongo.ini"
sudo ln -s /etc/php/"$2"/mods-available/mongo.ini /etc/php/"$2"/cli/conf.d/20-mongo.ini
sudo ln -s /etc/php/"$2"/mods-available/mongo.ini /etc/php/"$2"/fpm/conf.d/20-mongo.ini
sudo service php"$2"-fpm restart

mongosh admin --eval "db.createUser({user:'homestead',pwd:'secret',roles:['root']})"
