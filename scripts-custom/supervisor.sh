#!/bin/sh

echo 'Configuring Supervisor for Laravel...'

cp -f /vagrant/scripts-custom/configs/supervisor/* /etc/supervisor/conf.d/

supervisorctl reread
supervisorctl update
supervisorctl start unit3d-queue:*
supervisorctl start unit3d-socket-io:*
supervisorctl start chromedriver:*
