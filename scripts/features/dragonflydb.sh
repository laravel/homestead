#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/dragonflydb ]; then
    echo "Dragonflydb already installed."
    exit 0
fi

ARCH=$(arch)
DRAGONFLY_URL="https://dragonflydb.gateway.scarf.sh/latest/dragonfly-$ARCH.tar.gz"

# Install Dragonfly
if ! curl -sSL "$DRAGONFLY_URL" -o dragonflydb.tar.gz; then
    echo "Error downloading Dragonfly archive."
    exit 1
fi

if ! tar -xzf dragonflydb.tar.gz "dragonfly-$ARCH"; then
    echo "Error extracting Dragonfly archive."
    exit 1
fi

mv "dragonfly-$ARCH" /usr/local/bin/dragonfly

# Create systemd service file
cat > /etc/systemd/system/dragonfly.service << EOF
[Unit]
Description=DragonFly
After=network.target

[Service]
User=vagrant
ExecStart=/usr/bin/env /usr/local/bin/dragonfly

[Install]
WantedBy=multi-user.target
EOF

# Disable and stop redis
systemctl disable --now redis-server

# Enable and start dragonfly
systemctl enable --now dragonfly

# Clean up
rm -rf dragonflydb.tar.gz

# Mark installation as complete
touch /home/$WSL_USER_NAME/.homestead-features/dragonflydb
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features