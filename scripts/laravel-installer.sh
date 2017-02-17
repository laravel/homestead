#!/usr/bin/env bash

sudo -u vagrant -i composer global require "laravel/installer=~1.1";

sudo -u vagrant -i laravel list >/dev/null 2>&1 || sudo -u vagrant -i echo 'export PATH=$PATH:$HOME/.composer/vendor/bin' >> /home/vagrant/.profile;
