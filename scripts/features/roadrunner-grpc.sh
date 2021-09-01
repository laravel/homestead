#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/roadrunner-grpc ]
then
    echo "roadrunner-grpc already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/roadrunner-grpc
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

mkdir -p /usr/local/roadrunner
printf "\nPATH=\"/usr/local/roadrunner:\$PATH\"\n" | tee -a /home/vagrant/.profile

# Install Roadrunner GRPC
ROADRUNNER_GRPC_VERSION="1.5.0"
wget https://github.com/spiral/php-grpc/releases/download/v${ROADRUNNER_GRPC_VERSION}/rr-grpc-${ROADRUNNER_GRPC_VERSION}-linux-amd64.tar.gz -qO roadrunner-grpc.tar.gz
tar -xf roadrunner-grpc.tar.gz -C /usr/local/roadrunner --strip-components=1
rm -rf roadrunner-grpc.tar.gz

# Install Roadrunner GRPC
PROTOC_GEN_PHP_GRPC_VERSION="1.5.0"
wget https://github.com/spiral/php-grpc/releases/download/v${PROTOC_GEN_PHP_GRPC_VERSION}/protoc-gen-php-grpc-${PROTOC_GEN_PHP_GRPC_VERSION}-linux-amd64.tar.gz -qO protoc-gen-php-grpc.tar.gz
tar -xf protoc-gen-php-grpc.tar.gz -C /usr/local/roadrunner --strip-components=1
rm -rf protoc-gen-php-grpc.tar.gz
