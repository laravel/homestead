#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/fluentbit ]
then
    echo "fluentbit already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/fluentbit
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Fluentbit
wget -qO - http://packages.fluentbit.io/fluentbit.key | sudo apt-key add -

echo "deb http://packages.fluentbit.io/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/fluentbit.list

sudo apt-get update
sudo apt-get install -y td-agent-bit

sudo mv /etc/td-agent-bit/td-agent-bit.conf /etc/td-agent-bit/td-agent-bit.backup

sudo cat > /etc/td-agent-bit/td-agent-bit.conf <<EOL
[SERVICE]
    # Flush
    # =====
    # Set an interval of seconds before to flush records to a destination
    Flush        5
    # Daemon
    # ======
    # Instruct Fluent Bit to run in foreground or background mode.
    Daemon       Off
    # Log_Level
    # =========
    # Set the verbosity level of the service, values can be:
    #
    # - error
    # - warning
    # - info
    # - debug
    # - trace
    #
    # By default 'info' is set, that means it includes 'error' and 'warning'.
    Log_Level    info
    # Parsers_File
    # ============
    # Specify an optional 'Parsers' configuration file
    Parsers_File parsers.conf
[INPUT]
    Name   mem
    Tag    memory.local
[OUTPUT]
    Name  es
    Match memory*
    Host  127.0.0.1
    Port  9200
    Index system
    Type  system
[INPUT]
    Name   tail
    Refresh_Interval 360
    Path   /var/www/*/storage/logs/laravel-*.log
    Tag    app.local
[INPUT]
    Name   tail
    Refresh_Interval 360
    Path   /var/www/*/storage/logs/*cli*.log
    Tag    app.cli
[INPUT]
    Name   tail
    Refresh_Interval 360
    Path   /var/www/*/storage/logs/*fpm*.log
    Tag    app.fpm
[OUTPUT]
    Name  es
    Match app*
    Host  127.0.0.1
    Port  9200
    Index app
    Type  app
EOL

sudo systemctl enable td-agent-bit.service
sudo systemctl restart td-agent-bit.service
