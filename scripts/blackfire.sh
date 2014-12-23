#!/usr/bin/env bash

xdebug="/etc/php5/fpm/conf.d/20-xdebug.ini"

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

# Disable xdebug
if [ -f $xdebug ]; then
	rm $xdebug
	service hhvm restart
	service php5-fpm restart
fi

service blackfire-agent restart