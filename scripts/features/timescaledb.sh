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
sudo add-apt-repository -y ppa:timescale/timescaledb-ppa
sudo apt-get update

# Now install appropriate package for PG version
if [ -f ~/.homestead-features/wsl_user_name ]; then
    sudo apt-get -y install timescaledb-2-postgresql-13
else
    sudo apt-get -y install timescaledb-postgresql-9.6
    sudo apt-get -y install timescaledb-postgresql-10
    sudo apt-get -y install timescaledb-2-postgresql-11
    sudo apt-get -y install timescaledb-2-postgresql-12
    sudo apt-get -y install timescaledb-2-postgresql-13
fi

sudo timescaledb-tune --quiet --yes
if [ -f ~/.homestead-features/wsl_user_name ]; then
    printf "\ntimescaledb.telemetry_level=off\n" | sudo tee -a /etc/postgresql/13/main/postgresql.conf
else
    printf "\ntimescaledb.telemetry_level=off\n" | sudo tee -a /etc/postgresql/9.6/main/postgresql.conf
    printf "\ntimescaledb.telemetry_level=off\n" | sudo tee -a /etc/postgresql/10/main/postgresql.conf
    printf "\ntimescaledb.telemetry_level=off\n" | sudo tee -a /etc/postgresql/11/main/postgresql.conf
    printf "\ntimescaledb.telemetry_level=off\n" | sudo tee -a /etc/postgresql/12/main/postgresql.conf
    printf "\ntimescaledb.telemetry_level=off\n" | sudo tee -a /etc/postgresql/13/main/postgresql.conf
fi

sudo service postgresql restart
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features
