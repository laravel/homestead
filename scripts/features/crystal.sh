#!/usr/bin/env bash

if [ -f /home/vagrant/.homestead-features/crystal ]
then
    echo "Crystal already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/crystal
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Install Crystal Programming Language Support
apt-key adv --keyserver hkp://keys.gnupg.net:80 --recv-keys 09617FD37CC06B54
echo "deb https://dist.crystal-lang.org/apt crystal main" | tee /etc/apt/sources.list.d/crystal.list
apt-get update
apt-get install -y crystal

# Install Lucky Framework for Crystal

wget https://github.com/luckyframework/lucky_cli/archive/v0.11.0.tar.gz
tar -zxvf v0.11.0.tar.gz
cd lucky_cli-0.11.0
shards install
crystal build src/lucky.cr --release --no-debug
mv lucky /usr/local/bin/.
cd /home/vagrant
rm -rf lucky_cli-0.11.0
rm -rf v0.11.0.tar.gz
