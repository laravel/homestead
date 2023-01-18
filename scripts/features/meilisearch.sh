#!/bin/bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/meilisearch ]
then
    echo "meilisearch already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/meilisearch
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# add the sources for meilisearch
curl -L https://install.meilisearch.com | sh
mv ./meilisearch /usr/bin/

# Create a service file
cat > /etc/systemd/system/meilisearch.service << EOF
[Unit]
Description=MeiliSearch
After=systemd-user-sessions.service

[Service]
Type=simple
ExecStart=/usr/bin/meilisearch --http-addr '0.0.0.0:7700'

[Install]
WantedBy=default.target
EOF

# Set the service meilisearch
systemctl daemon-reload
systemctl enable meilisearch

# Start the meilisearch service
systemctl start meilisearch
