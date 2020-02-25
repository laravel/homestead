#!/bin/sh

echo 'Configuring Supervisor for Laravel...'

cp -f /vagrant/scripts-custom/configs/supervisor/* /etc/supervisor/conf.d/
sed -i "s|/home/vagrant/code|$1|" /etc/supervisor/conf.d/laravel-worker.conf

supervisorctl reread
supervisorctl update
supervisorctl start unit3d-queue:*
supervisorctl start unit3d-socket-io:*
supervisorctl start chromedriver:*
