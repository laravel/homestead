#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.homestead-features/ulimit65536 ]
then
    echo "ulimit65536 already installed."
    exit 0
fi


touch /home/vagrant/.homestead-features/ulimit65536
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

echo "soft nofile 65536" > "/etc/security/limits.conf"
echo "hard nofile 65536" > "/etc/security/limits.conf"
