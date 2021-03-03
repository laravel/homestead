#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.homestead-features/laravel-horizon-worker ]
then
    echo "Laravel Horizon Worker already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/laravel-horizon-worker
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

sudo rm -rf /etc/supervisor/conf.d/*.worker.conf

sudo cat > /etc/supervisor/conf.d/"$1".conf <<EOL
[program:$1]
process_name=%(program_name)s
command=php $2/artisan horizon
autostart=true
autorestart=true
user=vagrant
stopwaitsecs=660
redirect_stderr=true
stdout_logfile=/var/log/$1.log
stdout_logfile_maxbytes=1MB
EOL

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start "$1":*

sudo systemctl enable supervisor
sudo systemctl restart supervisor
