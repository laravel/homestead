#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/puppeteer ]
then
    echo "puppeteer already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/puppeteer
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Install Google Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee -a /etc/apt/sources.list.d/google-chrome.list

apt-get update

apt-get -y install libxpm4 libxrender1 libgtk2.0-0 libnss3 libgconf-2-4 xvfb gtk2-engines-pixbuf \
xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable imagemagick x11-apps google-chrome-stable \
fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf

npm config set puppeteer_skip_chromium_download true -g && npm install --unsafe-perm --global puppeteer

ln -s /usr/bin/google-chrome-stable /usr/bin/google-chrome
chmod -R o+rx /usr/bin/google-chrome*
