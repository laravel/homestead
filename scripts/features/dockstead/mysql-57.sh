#!/usr/bin/env bash

# Stop the default MySQL Service
sudo service mysql stop

# Update /home/vagrant/.my.cnf
sed -i "s/localhost/127.0.0.1/" /home/vagrant/.my.cnf

# Start the MySQL 5.7 stack
docker stack deploy -c /vagrant/scripts/features/dockstead/mysql-5.7.yaml mysql-57
echo "Sleeping for 30 seconds while we wait for MySQL service to come up"
sleep 30
