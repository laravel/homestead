#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/minio ]
then
    echo "minio already installed."
    exit 0
fi

ARCH=$(arch)


touch /home/$WSL_USER_NAME/.homestead-features/minio
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

if [[ "$ARCH" == "aarch64" ]]; then
  curl -sO https://dl.minio.io/server/minio/release/linux-arm64/minio
else
  curl -sO https://dl.minio.io/server/minio/release/linux-amd64/minio
fi

sudo chmod +x minio
sudo mv minio /usr/local/bin
sudo useradd -r minio-user -s /sbin/nologin
sudo mkdir /usr/local/share/minio
sudo mkdir /etc/minio

cat <<EOT >> /etc/default/minio
# Local export path.
MINIO_VOLUMES="/usr/local/share/minio/"
# Use if you want to run Minio on a custom port.
MINIO_OPTS="--config-dir /etc/minio --address :9600 --console-address :9601"
MINIO_CONFIG_ENV_FILE=/etc/default/minio
MINIO_ROOT_USER=homestead
MINIO_ROOT_PASSWORD=secretkey

EOT

sudo chown minio-user:minio-user /usr/local/share/minio
sudo chown minio-user:minio-user /etc/minio

curl -sO https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/minio.service
sudo mv minio.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable minio
sudo systemctl start minio

sudo ufw allow 9600

# Installing Minio Client
if [[ "$ARCH" == "aarch64" ]]; then
  curl -sO https://dl.minio.io/client/mc/release/linux-arm64/mc
else
  curl -sO https://dl.minio.io/client/mc/release/linux-amd64/mc
fi

chmod +x mc
sudo mv mc /usr/local/bin
mc config host add homestead http://127.0.1.1:9600 homestead secretkey
