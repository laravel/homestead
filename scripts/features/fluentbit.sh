#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.homestead-features/fluentbit ]
then
    echo "Fluent-bit already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/fluentbit
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

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
