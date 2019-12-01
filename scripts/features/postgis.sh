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

sudo apt-get update
sudo apt-get -y install postgresql-11-postgis-3 postgresql-11-postgis-3-scripts
