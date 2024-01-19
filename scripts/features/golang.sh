#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/golang ]
then
    echo "Golang already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/golang
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

ARCH=$(arch)

# Install Golang
if [[ "$ARCH" == "aarch64" ]]; then
    GOLANG_LATEST_STABLE_VERSION=$(curl https://go.dev/dl/?mode=json | grep -o 'go.*.linux-arm64.tar.gz' | head -n 1 | tr -d '\r\n')
    wget https://dl.google.com/go/${GOLANG_LATEST_STABLE_VERSION} -O golang.tar.gz
else
    GOLANG_LATEST_STABLE_VERSION=$(curl https://go.dev/dl/?mode=json | grep -o 'go.*.linux-amd64.tar.gz' | head -n 1 | tr -d '\r\n')
    wget https://dl.google.com/go/${GOLANG_LATEST_STABLE_VERSION} -O golang.tar.gz
fi

tar -C /usr/local -xzf golang.tar.gz go
printf "\nPATH=\"/usr/local/go/bin:\$PATH\"\n" | tee -a /home/vagrant/.profile
rm -rf golang.tar.gz
