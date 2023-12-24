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
  echo "deb [ arch=arm64,arm64 signed-by=/usr/share/keyrings/mongodb-server-$1.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/$1 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-$1.list
else
  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-$1.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/$1 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-$1.list
fi

curl -fsSL https://pgp.mongodb.com/server-$1.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-$1.gpg --dearmor

sudo apt-get update

sudo apt-get install -y mongodb-org

sudo ufw allow 27017
sudo sed -i "s/bindIp: .*/bindIp: 0.0.0.0/" /etc/mongod.conf

sudo systemctl enable mongod
sudo systemctl start mongod

sudo rm -rf /tmp/mongo-php-driver /usr/src/mongo-php-driver
git clone -c advice.detachedHead=false -q -b "$2" --single-branch https://github.com/mongodb/mongo-php-driver.git /tmp/mongo-php-driver
sudo mv /tmp/mongo-php-driver /usr/src/mongo-php-driver
cd /usr/src/mongo-php-driver
git submodule -q update --init

phpize"$3"
./configure --with-php-config=/usr/bin/php-config"$3" > /dev/null
make clean > /dev/null
make >/dev/null 2>&1
sudo make install
sudo bash -c "echo 'extension=mongodb.so' > /etc/php/$3/mods-available/mongo.ini"
sudo ln -s /etc/php/"$3"/mods-available/mongo.ini /etc/php/"$3"/cli/conf.d/20-mongo.ini
sudo ln -s /etc/php/"$3"/mods-available/mongo.ini /etc/php/"$3"/fpm/conf.d/20-mongo.ini
sudo service php"$3"-fpm restart

mongosh admin --eval "db.createUser({user:'homestead',pwd:'secret',roles:['root']})"
