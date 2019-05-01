#!/usr/bin/env bash

# Install Zend Z-Ray (for FPM only, not CLI)

sudo wget http://repos.zend.com/zend-server/early-access/ZRay-Homestead/zray-standalone-php72.tar.gz -O - | sudo tar -xzf - -C /opt
sudo chown -R vagrant:vagrant /opt/zray
