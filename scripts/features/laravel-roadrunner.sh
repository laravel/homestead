#!/usr/bin/env bash

if [ -f /home/vagrant/.homestead-features/roadrunner ]
then
    echo "Laravel Roadrunner already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/roadrunner
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

mkdir -p /usr/local/roadrunner
printf "\nPATH=\"/usr/local/roadrunner:\$PATH\"\n" | tee -a /home/vagrant/.profile

# Install Laravel Roadrunner
roadrunnerVersion="1.8.3"
wget https://github.com/spiral/roadrunner/releases/download/v${roadrunnerVersion}/roadrunner-${roadrunnerVersion}-linux-amd64.tar.gz -qO roadrunner.tar.gz
tar -xf roadrunner.tar.gz -C /usr/local/roadrunner --strip-components=1
rm -rf roadrunner.tar.gz

