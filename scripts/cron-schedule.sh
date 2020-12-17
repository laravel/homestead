#!/usr/bin/env bash

if [ ! -d /etc/cron.d ]; then
    mkdir /etc/cron.d
fi

SITE_DOMAIN=$1
SITE_PUBLIC_DIRECTORY=$2
SITE_PHP_VERSION=$3

cron="* * * * * vagrant  . /home/vagrant/.profile; /usr/bin/php$SITE_PHP_VERSION $SITE_PUBLIC_DIRECTORY/../artisan schedule:run >> /dev/null 2>&1"

echo "$cron" > "/etc/cron.d/$SITE_DOMAIN"
