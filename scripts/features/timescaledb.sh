#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.homestead-features/timescale ]
then
    echo "TimescaleDB already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/timescale
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Add TimeScaleDB PPA
sudo add-apt-repository -y ppa:timescale/timescaledb-ppa
sudo apt-get update

# Now install appropriate package for PG version
sudo apt-get -y install timescaledb-oss-postgresql-9.6
sudo apt-get -y install timescaledb-oss-postgresql-10
sudo apt-get -y install timescaledb-oss-postgresql-11
sudo apt-get -y install timescaledb-oss-postgresql-12

sudo timescaledb-tune --quiet --yes
printf "\ntimescaledb.telemetry_level=off\n" | sudo tee -a /etc/postgresql/9.6/main/postgresql.conf
printf "\ntimescaledb.telemetry_level=off\n" | sudo tee -a /etc/postgresql/10/main/postgresql.conf
printf "\ntimescaledb.telemetry_level=off\n" | sudo tee -a /etc/postgresql/11/main/postgresql.conf
printf "\ntimescaledb.telemetry_level=off\n" | sudo tee -a /etc/postgresql/12/main/postgresql.conf

sudo service postgresql restart
