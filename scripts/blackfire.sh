#!/usr/bin/env bash

agent="[blackfire]
ca-cert=
collector=https://blackfire.io
log-file=stderr
log-level=1
server-id="$1"
server-token="$2"
socket=unix:///var/run/blackfire/agent.sock
spec=
"

client="[blackfire]
ca-cert=
client-id="$3"
client-token="$4"
endpoint=https://blackfire.io
timeout=15s
"

echo "$agent" > "/etc/blackfire/agent"
echo "$client" > "/home/vagrant/.blackfire.ini"

service php5.6-fpm restart
service php7.0-fpm restart
service php7.1-fpm restart
service php7.2-fpm restart
service blackfire-agent restart
