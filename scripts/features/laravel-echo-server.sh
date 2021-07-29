#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.homestead-features/laravel-echo-server ]
then
    echo "Laravel Echo Server already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/laravel-echo-server
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Install laravel echo server globally
sudo npm install -g --unsafe-perm laravel-echo-server
sudo chmod -R o+rx /usr/bin/laravel-echo-server

SERVICE_CONF="
[Unit]
Description=Laravel Echo - socket.io server
Requires=After=redis-server.service
[Service]
User=vagrant
Group=vagrant
ExecStart=/usr/bin/laravel-echo-server start --dir=${1}
Restart=always
RestartSec=10
SyslogIdentifier=laravel-echo-server
StandardOutput=syslog
StandardError=syslog
Environment=NODE_ENV=production LARAVEL_ECHO_SERVER_PORT=${2} LARAVEL_ECHO_SERVER_AUTH_HOST=${3}
[Install]
WantedBy=multi-user.target
"

echo "$SERVICE_CONF" | sudo tee /etc/systemd/system/laravel-echo-server.service

sudo systemctl daemon-reload

sudo systemctl enable laravel-echo-server.service
sudo systemctl restart laravel-echo-server.service

# update ca-certificates for laravel-echo-server
sudo cp /etc/ssl/certs/*.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates -y
