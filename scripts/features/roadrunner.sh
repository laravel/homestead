#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive
ROADRUNNER_VERSION="2.6.3"

if [ -f /home/$WSL_USER_NAME/.homestead-features/roadrunner-$ROADRUNNER_VERSION ]
then
    echo "roadrunner-$ROADRUNNER_VERSION already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/roadrunner-$ROADRUNNER_VERSION
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Install Roadrunner CLI
wget https://github.com/spiral/roadrunner-binary/releases/download/v${ROADRUNNER_VERSION}/roadrunner-${ROADRUNNER_VERSION}-linux-amd64.tar.gz -qO roadrunner.tar.gz
tar -xf roadrunner.tar.gz -C /usr/local/bin/ --strip-components=1
rm -rf roadrunner.tar.gz
rm -rf /usr/bin/rr
ln -s /usr/local/bin/rr /usr/bin/rr
