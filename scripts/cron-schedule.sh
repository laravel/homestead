#!/usr/bin/env bash

if [ ! -d /etc/cron.d ]; then
    mkdir /etc/cron.d
fi

cron="* * * * * vagrant /usr/bin/php $2/../artisan schedule:run >> /dev/null 2>&1"

echo "$cron" > "/etc/cron.d/$1"

service cron restart
