#!/usr/bin/env bash

mkdir /etc/supervisor/conf.d 2>/dev/null

worker="[program:$1-worker]
process_name=%(program_name)s_%(process_num)02d
command=php $2/../artisan queue:work --sleep=3 --tries=3 --daemon
autostart=true
autorestart=true
user=vagrant
numprocs=8
redirect_stderr=true
stdout_logfile=$2/worker.log"

echo "$worker" > "/etc/supervisor/conf.d/$1-worker.conf"

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start all
