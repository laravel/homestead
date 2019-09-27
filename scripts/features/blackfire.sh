#!/usr/bin/env bash

if [ -f /home/vagrant/.homestead-features/blackfire ]
then
    echo "blackfire already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/blackfire
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

wget -q -O - https://packages.blackfire.io/gpg.key | apt-key add -
echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list

# Install Blackfire
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y blackfire-agent blackfire-php

agent="[blackfire]
ca-cert=
collector=https://blackfire.io
log-file=stderr
log-level=1
server-id=${server_id}
server-token=${server_token}
socket=unix:///var/run/blackfire/agent.sock
spec=
"

client="[blackfire]
ca-cert=
client-id=${client_id}
client-token=${client_token}
endpoint=https://blackfire.io
timeout=15s
"

echo "$agent" > "/etc/blackfire/agent"
echo "$client" > "/home/vagrant/.blackfire.ini"

service php5.6-fpm restart
service php7.0-fpm restart
service php7.1-fpm restart
service php7.2-fpm restart
service php7.3-fpm restart
service php7.4-fpm restart
service blackfire-agent restart
