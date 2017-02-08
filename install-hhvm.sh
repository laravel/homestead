# install HHVM
sudo apt-get -y install hhvm

# ensure webserver can talk to HHVM over FastCGI
sudo /usr/share/hhvm/install_fastcgi.sh
sudo /etc/init.d/nginx restart

# ensure hhvm starts up at boot
sudo update-rc.d hhvm defaults

# enable the system use HHVM for /usr/bin/php
sudo /usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60