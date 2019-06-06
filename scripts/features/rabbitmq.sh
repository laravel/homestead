#!/usr/bin/env bash

# Check If rabbitmq Has Been Installed

if [ -f /home/vagrant/.homestead-features/rabbitmq ]
then
    echo "rabbitmq already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/rabbitmq


# Install Erlang

wget -q -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo apt-key add -
echo "deb https://packages.erlang-solutions.com/ubuntu bionic contrib" | sudo tee /etc/apt/sources.list.d/rabbitmq.list
sudo apt-get update
sudo apt-get -y install erlang

# Install RabbitMQ

wget -q -O- https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc | sudo apt-key add -
wget -q -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
echo "deb https://dl.bintray.com/rabbitmq/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/rabbitmq.list
sudo apt-get update
sudo apt-get -y install rabbitmq-server php-amqp php-bcmath

# Enable RabbitMQ HTTP Admin Interface
sudo rabbitmq-plugins enable rabbitmq_management
sudo rabbitmqctl add_user homestead homestead
sudo rabbitmqctl set_user_tags homestead administrator
sudo rabbitmqctl set_permissions -p / homestead ".*" ".*" ".*"