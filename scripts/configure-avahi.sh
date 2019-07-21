#!/usr/bin/env bash

sed -i "s/#browse-domains=.*/browse-domains=$1/" /etc/avahi/avahi-daemon.conf
sed -i "s/browse-domains=.*/browse-domains=$1/" /etc/avahi/avahi-daemon.conf
service avahi-daemon restart
