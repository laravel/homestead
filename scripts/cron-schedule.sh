#!/usr/bin/env bash

mkdir /etc/cron.d 2>/dev/null

cron="* * * * * vagrant /usr/bin/php $2/../artisan schedule:run >> /dev/null 2>&1"

echo "$cron" > "/etc/cron.d/$1"
service cron restart
