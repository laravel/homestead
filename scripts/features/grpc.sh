#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/grpc ]
then
    echo "grpc already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/grpc
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

PROTOC_VERSION=21.7
PROTOC_ZIP=protoc.zip
wget -qO $PROTOC_ZIP https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOC_VERSION/protoc-$PROTOC_VERSION-linux-x86_64.zip
sudo unzip -o $PROTOC_ZIP -d /usr/local/protoc
sudo ln -s /usr/local/protoc/bin/protoc /usr/local/bin/protoc
sudo chmod +x /usr/local/bin/protoc
sudo rm -f $PROTOC_ZIP

# Update PECL Channel
sudo pecl channel-update pecl.php.net
# Install protobuf and grpc
sudo pecl install protobuf
sudo pecl install grpc

sudo bash -c "echo 'extension=grpc.so' > /etc/php/8.0/mods-available/grpc.ini"
sudo ln -s /etc/php/8.0/mods-available/grpc.ini /etc/php/8.0/cli/conf.d/20-grpc.ini
sudo ln -s /etc/php/8.0/mods-available/grpc.ini /etc/php/8.0/fpm/conf.d/20-grpc.ini

sudo bash -c "echo 'extension=protobuf.so' > /etc/php/8.0/mods-available/protobuf.ini"
sudo ln -s /etc/php/8.0/mods-available/protobuf.ini /etc/php/8.0/cli/conf.d/20-protobuf.ini
sudo ln -s /etc/php/8.0/mods-available/protobuf.ini /etc/php/8.0/fpm/conf.d/20-protobuf.ini
sudo service php8.0-fpm restart
