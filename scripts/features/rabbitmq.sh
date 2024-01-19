#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/rabbitmq ]
then
    echo "rabbitmq already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/rabbitmq
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

sudo apt-get install curl gnupg debian-keyring debian-archive-keyring apt-transport-https -y

# Import signing keys
curl -1sLf "https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA" | sudo gpg --dearmor -o /etc/apt/keyrings/com.rabbitmq.team.gpg
curl -1sLf "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xf77f1eda57ebb1cc" | sudo gpg --dearmor -o /etc/apt/keyrings/net.launchpad.ppa.rabbitmq.erlang.gpg
curl -1sLf "https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey" | sudo gpg --dearmor -o /etc/apt/keyrings/io.packagecloud.rabbitmq.gpg

## Add apt repositories maintained by Team RabbitMQ
tee /etc/apt/sources.list.d/rabbitmq.list <<EOF
deb [signed-by=/etc/apt/keyrings/net.launchpad.ppa.rabbitmq.erlang.gpg] http://ppa.launchpad.net/rabbitmq/rabbitmq-erlang/ubuntu jammy main
deb-src [signed-by=/etc/apt/keyrings/net.launchpad.ppa.rabbitmq.erlang.gpg] http://ppa.launchpad.net/rabbitmq/rabbitmq-erlang/ubuntu jammy main
deb [signed-by=/etc/apt/keyrings/io.packagecloud.rabbitmq.gpg] https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu/ jammy main
deb-src [signed-by=/etc/apt/keyrings/io.packagecloud.rabbitmq.gpg] https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu/ jammy main
EOF

## Update package indices
apt-get update

## Install Erlang packages
apt-get install -y erlang-base \
                        erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets \
                        erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key \
                        erlang-runtime-tools erlang-snmp erlang-ssl \
                        erlang-syntax-tools erlang-tftp erlang-tools erlang-xmerl

## Install rabbitmq-server and its dependencies
apt-get install rabbitmq-server php-amqp php-bcmath -y --fix-missing

# Enable RabbitMQ HTTP Admin Interface
rabbitmq-plugins enable rabbitmq_management
rabbitmqctl add_user homestead secret
rabbitmqctl set_user_tags homestead administrator
rabbitmqctl set_permissions -p / homestead ".*" ".*" ".*"
rabbitmqctl set_topic_permissions -p / homestead ".*" ".*" ".*"

# Install rabbitmqadmin CLI tool - https://www.rabbitmq.com/management-cli.html
wget -q http://localhost:15672/cli/rabbitmqadmin -O /usr/local/bin/rabbitmqadmin
chmod +x /usr/local/bin/rabbitmqadmin
