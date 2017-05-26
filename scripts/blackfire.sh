#!/usr/bin/env bash

cat <<- __EOF__ > /etc/blackfire/agent
[blackfire]
ca-cert=
collector=https://blackfire.io
log-file=stderr
log-level=1
server-id="${1}"
server-token="${2}"
socket=unix:///var/run/blackfire/agent.sock
spec=
__EOF__

cat <<- __EOF__ > /home/vagrant/.blackfire.ini
[blackfire]
ca-cert=
client-id="${3}"
client-token="${4}"
endpoint=https://blackfire.io
timeout=15s
__EOF__

echo "php7.1-fpm blackfire-agent" | \
xargs -n1 bash -c 'service ${0} restart; sleep 0.1'
