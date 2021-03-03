#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.homestead-features/laravel-worker ]
then
    echo "Laravel Worker already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/laravel-worker
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

sudo rm -rf /etc/supervisor/conf.d/*.worker.conf

sudo cat > /etc/supervisor/conf.d/"$1".conf <<EOL
[program:$1]
process_name=%(program_name)s_%(process_num)02d
command=php $2/artisan queue:work $3 --queue=high,default,low --sleep=3 --tries=3 --timeout=660
autostart=true
autorestart=true
user=vagrant
numprocs=$4
redirect_stderr=true
stdout_logfile=/var/log/$1.log
stdout_logfile_maxbytes=1MB
EOL

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start "$1":*

sudo systemctl enable supervisor
sudo systemctl restart supervisor
