#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.homestead-features/grpc ]
then
    echo "grpc extension already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/grpc
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

PROTOC_VERSION=3.15.7
PROTOC_ZIP=protoc.zip
wget -qO $PROTOC_ZIP https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOC_VERSION/protoc-$PROTOC_VERSION-linux-x86_64.zip
sudo unzip -o $PROTOC_ZIP -d /usr/local/protoc
sudo ln -s /usr/local/protoc/bin/protoc /usr/local/bin/protoc
sudo chmod +x /usr/local/bin/protoc
sudo rm -f $PROTOC_ZIP

sudo apt-get update

sudo update-alternatives --set php /usr/bin/php${1}
sudo update-alternatives --set php-config /usr/bin/php-config${1}
sudo update-alternatives --set phpize /usr/bin/phpize${1}
sudo pecl -d php_suffix=${1} install -f grpc
sudo pecl -d php_suffix=${1} install -f protobuf
sudo pecl uninstall -r grpc
sudo pecl uninstall -r protobuf

sudo bash -c "echo 'extension=grpc.so' > /etc/php/${1}/mods-available/grpc.ini"
sudo ln -s /etc/php/${1}/mods-available/grpc.ini /etc/php/${1}/cli/conf.d/20-grpc.ini
sudo ln -s /etc/php/${1}/mods-available/grpc.ini /etc/php/${1}/fpm/conf.d/20-grpc.ini

sudo bash -c "echo 'extension=protobuf.so' > /etc/php/${1}/mods-available/protobuf.ini"
sudo ln -s /etc/php/${1}/mods-available/protobuf.ini /etc/php/${1}/cli/conf.d/20-protobuf.ini
sudo ln -s /etc/php/${1}/mods-available/protobuf.ini /etc/php/${1}/fpm/conf.d/20-protobuf.ini
sudo service php${1}-fpm restart
