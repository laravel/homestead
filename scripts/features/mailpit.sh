#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/mailpit ]
then
    echo "mailpit already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/mailpit
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

curl -sL https://raw.githubusercontent.com/axllent/mailpit/develop/install.sh | sh

chown -f $WSL_USER_NAME:$WSL_USER_GROUP /usr/local/bin/mailpit

cat > /etc/systemd/system/mailpit.service << EOF
[Unit]
Description=Mailpit
After=network.target

[Service]
User=vagrant
ExecStart=/usr/bin/env /usr/local/bin/mailpit

[Install]
WantedBy=multi-user.target
EOF

systemctl disable --now mailhog

systemctl enable --now mailpit
