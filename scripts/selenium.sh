#!/usr/bin/env bash
#
# Bash script to setup headless Selenium for Homestead (uses Xvfb and Chrome)
# Implemented from https://medium.com/@splatEric/laravel-dusk-on-homestead-dc5711987595#.wkl09lx2x

sudo apt-get update
sudo apt-get -y install libxpm4 libxrender1 libgtk2.0-0 libnss3 libgconf-2-4
sudo apt-get -y install chromium-browser
sudo apt-get -y install xvfb gtk2-engines-pixbuf
sudo apt-get -y install xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable
sudo apt-get -y install imagemagick x11-apps

echo "Dependencies installed."
