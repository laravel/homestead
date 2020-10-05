#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.homestead-features/jdk ]
then
    echo "JDK already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/jdk
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

sudo apt-get update

sudo apt-get install -y default-jdk

echo $JAVA_HOME
