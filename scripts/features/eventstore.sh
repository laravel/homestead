#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/eventstore ]
then
    echo "eventstore already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/eventstore
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Determine wanted version from config
set -- "$1"
IFS=".";

if [ -z "${version}" ]; then
    installVersion="" # by not specifying we'll install latest
else
    installVersion="=${version}"
fi

# Install repository
curl -s https://packagecloud.io/install/repositories/EventStore/EventStore-OSS/script.deb.sh | bash

# Install EventStore package
apt-get install -y eventstore-oss"$installVersion"

# Update configuration
sed -i "s/RunProjections: None/RunProjections: ${run_projections:-All}/" /etc/eventstore/eventstore.conf

configuration="
extIp: ${external_ip:-0.0.0.0}
extTcpPort: ${external_tcp_port:-2112}
extHttpPort: ${external_http_port:-2113}
AdminOnExt: ${admin_on_ext:-true}
"
echo "$configuration" >> /etc/eventstore/eventstore.conf

# Allow the Event Store executable to bind to a port lower than 1024
setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/eventstored

# Enable and Start EventStore
systemctl enable eventstore.service
systemctl start eventstore.service
