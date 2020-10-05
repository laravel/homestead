#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/crystal ]
then
    echo "crystal already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/crystal
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Install Crystal Programming Language Support
curl -sL "https://keybase.io/crystal/pgp_keys.asc" | sudo apt-key add -
echo "deb https://dist.crystal-lang.org/apt crystal main" | sudo tee /etc/apt/sources.list.d/crystal.list
apt-get update
apt-get install -y crystal

# Install Lucky Framework for Crystal

wget https://github.com/luckyframework/lucky_cli/archive/v0.11.0.tar.gz
tar -zxvf v0.11.0.tar.gz
cd lucky_cli-0.11.0
shards install
crystal build src/lucky.cr --release --no-debug
mv lucky /usr/local/bin/.
cd /home/vagrant
rm -rf lucky_cli-0.11.0
rm -rf v0.11.0.tar.gz
