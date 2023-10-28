#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/rust ]; then
    echo "Rust is already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/rust
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Run the Rust installation script as the user
sudo -u $WSL_USER_NAME curl https://sh.rustup.rs -sSf | sudo -u $WSL_USER_NAME sh -s -- -y