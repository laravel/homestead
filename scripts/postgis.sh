#!/usr/bin/env bash

if [ -f /home/vagrant/.homestead-features/postgis ]
then
    echo "PostGIS already installed."
    exit 0
fi

if ! (hash psql 2> /dev/null); then
echo >&2 "PostGIS could not be installed because postgresql is missing."
exit 0
fi

touch /home/vagrant/.homestead-features/postgis

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt bionic-pgdg main" >> /etc/apt/sources.list'
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -

sudo apt update
sudo apt-get -y install postgresql-11-postgis-2.5 postgresql-11-postgis-scripts
