#!/usr/bin/env bash

if [ -f /home/vagrant/.homestead-features/roadrunner ]
then
    echo "Roadrunner already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/roadrunner
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Install Roadrunner CLI
roadrunnerVersion="2.0.4"
wget https://github.com/spiral/roadrunner-binary/releases/download/v${roadrunnerVersion}/roadrunner-${roadrunnerVersion}-linux-amd64.tar.gz -qO roadrunner.tar.gz
tar -xf roadrunner.tar.gz -C /usr/local/bin/ --strip-components=1
rm -rf roadrunner.tar.gz
