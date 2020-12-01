#!/usr/bin/env bash

# Check If rvm Has Been Installed

if [ -f /home/vagrant/.homestead-features/rvm ]
then
    echo "rvm already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/rvm
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Install RVM
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable --ruby --gems=bundler

# To start using RVM we need to run
source /home/vagrant/.rvm/scripts/rvm
