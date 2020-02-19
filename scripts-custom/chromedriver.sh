#!/bin/sh

# Install the latest Chrome version to prevent "Chrome version must be >= X"
# when running Dusk tests.

sudo curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add
# TODO This is not idempotent and should be fixed; it results in duplicate
# source warnings on subsequent executions.
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get -y update
sudo apt-get -y install google-chrome-stable

# Install the latest chromedriver globally; using the Composer-installed version
# from any given project is less reliable if using a mounted filesystem.

CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`
wget -N -q http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/
unzip -qq ~/chromedriver_linux64.zip -d ~/
rm ~/chromedriver_linux64.zip
sudo mv -f ~/chromedriver /usr/local/bin/chromedriver
sudo chown root:root /usr/local/bin/chromedriver
sudo chmod 0755 /usr/local/bin/chromedriver

# Add all Homestead-generated certificates to the "vagrant" user's trusted
# certificate store for Chrome. For more info:
# https://chromium.googlesource.com/chromium/src/+/lkcr/docs/linux_cert_management.md

sudo apt-get -y install libnss3-tools

# We don't want a password on the certificate database; see:
# https://bugzilla.redhat.com/show_bug.cgi?id=1401606

if [ -d "$HOME/.pki/nssdb" ]; then
    rm -rf $HOME/.pki/nssdb
fi

mkdir -p $HOME/.pki/nssdb
certutil -N -d $HOME/.pki/nssdb --empty-password

# Iterate through all Homestead-generated certificates and add them to the trusted
# store. Many of the certificates may be identical (because Homestead generates
# wildcards), in which case "certutil -d sql:$HOME/.pki/nssdb -L" command will
# show only one instance of each identical cert.

for file in /etc/nginx/ssl/*.crt; do
    [ -e "$file" ] || continue
    
    certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n "$file" -i "$file"
done
