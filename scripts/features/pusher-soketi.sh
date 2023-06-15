#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/soketi ]
then
    echo "Pusher Soketi already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/soketi
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Install Pusher Soketi server globally
sudo npm install -g --unsafe-perm @soketi/soketi
sudo chmod -R o+rx /usr/bin/soketi

SERVICE_CONF="
[Unit]
Description=Pusher Soketi server
Requires=redis-server.service
[Service]
User=vagrant
Group=vagrant
ExecStart=/usr/bin/soketi start --config=${1}
Restart=always
RestartSec=10
SyslogIdentifier=soketi
StandardOutput=syslog
StandardError=syslog
Environment=NODE_ENV=production SOKETI_DEBUG=1
[Install]
WantedBy=multi-user.target
"

echo "$SERVICE_CONF" | sudo tee /etc/systemd/system/soketi.service

sudo systemctl daemon-reload

sudo systemctl enable soketi.service
sudo systemctl restart soketi.service

# update ca-certificates for soketi
sudo cp /etc/ssl/certs/*.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates -y
