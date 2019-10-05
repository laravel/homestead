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
sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -c -s`-pgdg main' >> /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo add-apt-repository -y ppa:timescale/timescaledb-ppa
sudo apt-get update

# Now install appropriate package for PG version
sudo apt-get -y install timescaledb-oss-postgresql-11

sudo timescaledb-tune --quiet --yes
printf "\ntimescaledb.telemetry_level=off\n" | sudo tee -a /etc/postgresql/11/main/postgresql.conf

sudo service postgresql restart
