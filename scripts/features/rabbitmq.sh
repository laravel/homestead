#!/usr/bin/env bash

# Check If rabbitmq Has Been Installed

if [ -f /home/vagrant/.homestead-features/rabbitmq ]
then
    echo "rabbitmq already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/rabbitmq
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Setup Repositories
wget -q -O- https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc | sudo apt-key add -
wget -q -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list <<EOF
## Installs the latest Erlang 23.x release.
## Change component to "erlang-22.x" to install the latest 22.x version.
## Example: deb https://dl.bintray.com/rabbitmq-erlang/debian $distribution $component
## "bionic" as distribution name should work for any later Ubuntu or Debian release.
## See the release to distribution mapping table in RabbitMQ doc guides to learn more.
deb https://dl.bintray.com/rabbitmq-erlang/debian focal erlang

## Installs latest RabbitMQ release
deb https://dl.bintray.com/rabbitmq/debian focal main
EOF
sudo apt-get update

# Install RabbitMQ
sudo apt-get -y install rabbitmq-server php-amqp php-bcmath

# Enable RabbitMQ HTTP Admin Interface
sudo rabbitmq-plugins enable rabbitmq_management
sudo rabbitmqctl add_user homestead secret
sudo rabbitmqctl set_user_tags homestead administrator
sudo rabbitmqctl set_permissions -p / homestead ".*" ".*" ".*"
