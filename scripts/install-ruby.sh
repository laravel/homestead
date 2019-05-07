#!/usr/bin/env bash

# Install Ruby & rbenv

apt-get -y install libssl-dev libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common \
libffi-dev

git clone https://github.com/rbenv/rbenv.git /home/vagrant/.rbenv
cd /home/vagrant/.rbenv && src/configure && make -C src && cd -
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.profile
echo 'eval "$(rbenv init -)"' >> /home/vagrant/.profile

git clone https://github.com/rbenv/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> /home/vagrant/.profile

rbenv install 2.6.1
rbenv global 2.6.1
apt-get -y install ruby`ruby -e 'puts RUBY_VERSION[/\d+\.\d+/]'`-dev
gem install rails -v 5.2.2
rbenv rehash
chown -Rf vagrant:vagrant /home/vagrant/.rbenv
