#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/laravel-octane ]
then
    echo "laravel-octane already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/laravel-octane
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

sudo rm -rf /etc/supervisor/conf.d/"$1".conf

sudo cat > /etc/supervisor/conf.d/"$1".conf <<EOL
[program:$1]
process_name=%(program_name)s
command=php $2/artisan octane:start --watch --max-requests=250 --server=roadrunner --port=18000 --rpc-port=18001 --workers=4
autostart=true
autorestart=true
user=vagrant
redirect_stderr=true
stdout_logfile=/var/log/$1.log
stdout_logfile_maxbytes=1MB
EOL

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start "$1":*

sudo systemctl enable supervisor
sudo systemctl restart supervisor
