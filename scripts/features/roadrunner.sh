#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/roadrunner-$1 ]
then
    echo "roadrunner-$1 already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/roadrunner-$1
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Install Roadrunner CLI
wget https://github.com/roadrunner-server/roadrunner/releases/download/v$1/roadrunner-$1-linux-amd64.tar.gz -qO roadrunner.tar.gz
tar -xf roadrunner.tar.gz -C /usr/local/bin/ --strip-components=1
rm -rf roadrunner.tar.gz
rm -rf /usr/bin/rr
ln -s /usr/local/bin/rr /usr/bin/rr

# Install Roadrunner GRPC
wget https://github.com/roadrunner-server/roadrunner/releases/download/v$1/protoc-gen-php-grpc-$1-linux-amd64.tar.gz -qO protoc-gen-php-grpc.tar.gz
tar -xf protoc-gen-php-grpc.tar.gz -C /usr/local/bin/ --strip-components=1
rm -rf protoc-gen-php-grpc.tar.gz
rm -rf /usr/bin/protoc-gen-php-grpc
ln -s /usr/local/bin/protoc-gen-php-grpc /usr/bin/protoc-gen-php-grpc
