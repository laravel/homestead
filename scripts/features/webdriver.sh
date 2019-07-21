#!/usr/bin/env bash

if [ -f /home/vagrant/.homestead-features/webdriverutils ]
then
    echo "Web Driver utilities already installed."
    exit 0
fi

touch /home/vagrant/.homestead-features/webdriverutils
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

# Install The Chrome Web Driver & Dusk Utilities

apt-get update
apt-get -y install libxpm4 libxrender1 libgtk2.0-0 libnss3 libgconf-2-4 chromium-browser xvfb gtk2-engines-pixbuf \
xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable imagemagick x11-apps
