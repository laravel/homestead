#!/usr/bin/env bash

if [ -f /home/vagrant/.homestead-features/roadrunner-grpc ]
then
    echo "Laravel Roadrunner GRPC already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/roadrunner-grpc
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

mkdir -p /usr/local/roadrunner
printf "\nPATH=\"/usr/local/roadrunner:\$PATH\"\n" | tee -a /home/vagrant/.profile

# Install Roadrunner GRPC
roadrunnerGRPCVersion="1.4.0"
wget https://github.com/spiral/php-grpc/releases/download/v${roadrunnerGRPCVersion}/rr-grpc-${roadrunnerGRPCVersion}-linux-amd64.tar.gz -qO roadrunner-grpc.tar.gz
tar -xf roadrunner-grpc.tar.gz -C /usr/local/roadrunner --strip-components=1
rm -rf roadrunner-grpc.tar.gz

# Install Roadrunner GRPC
protocGenPhpGRPCVersion="1.4.0"
wget https://github.com/spiral/php-grpc/releases/download/v${protocGenPhpGRPCVersion}/protoc-gen-php-grpc-${protocGenPhpGRPCVersion}-linux-amd64.tar.gz -qO protoc-gen-php-grpc.tar.gz
tar -xf protoc-gen-php-grpc.tar.gz -C /usr/local/roadrunner --strip-components=1
rm -rf protoc-gen-php-grpc.tar.gz
