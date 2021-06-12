#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/ngrok ]
then
    echo "ngrok already installed."
    exit 0
fi

# Grab parameters from configuration
set -- "$1"

# Check for authtoken (required)
if [ -z "${authtoken}" ]; then
    echo "authtoken parameter necessary for ngrok. ngrok not installed!"
    exit 0
fi
authToken="${authtoken}"

# Check for region (not required, default=us)
regionConfig="us"
if [ "${region}" != "" ]; then
    regionConfig="${region}"
fi

# Mark ngrok feature installed
touch /home/$WSL_USER_NAME/.homestead-features/ngrok
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Install ngrok
sudo snap install ngrok
# Install auth token
echo "Setting up ngrok..."

# create empty ngrok dir and config file manually. For some reason
# `su $WSL_USER_NAME ngrok authtoken <token>` does not work as expected
NGROK_USERDIR=/home/$WSL_USER_NAME/.ngrok2
NGROK_CONFIG=$NGROK_USERDIR/ngrok.yml
if [ ! -d $NGROK_USERDIR ]; then
    mkdir $NGROK_USERDIR
fi
touch $NGROK_CONFIG

# save authtoken and region to config file
cat <<EOF >> $NGROK_CONFIG
authtoken: $authToken
region: $regionConfig
EOF

chown $WSL_USER_NAME:$WSL_USER_GROUP $NGROK_USERDIR $NGROK_CONFIG

echo "Setting up alias..."
echo "run ngrok with command 'rock www.youraliasdomain.com'"

cat <<'EOF' >> /home/$WSL_USER_NAME/.bashrc
function rock(){
  ngrok http $1:80 -host-header=$1 ${@:2}
}
EOF

exit 0
