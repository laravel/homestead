#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/timescale ]
then
    echo "TimescaleDB already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/timescale

# Add TimeScaleDB PPA
sudo sh -c "echo 'deb https://packagecloud.io/timescale/timescaledb/ubuntu/ `lsb_release -c -s` main' > /etc/apt/sources.list.d/timescaledb.list"
wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | sudo apt-key add -
sudo apt-get update

sudo apt-get -y install timescaledb-2-postgresql-13

sudo timescaledb-tune --quiet --yes
printf "\ntimescaledb.telemetry_level=off\n" | sudo tee -a /etc/postgresql/13/main/postgresql.conf

sudo service postgresql restart

chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features
