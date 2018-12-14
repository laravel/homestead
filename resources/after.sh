#!/bin/sh

sudo apt-get update
sudo apt-get install -y alien wget

mkdir downloads
cd downloads

# official oracle instant client http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html
echo 'Downloading oracle instant client basic'
wget -nv https://www.dropbox.com/s/q7fkj3d1hn2scrl/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm

echo 'download oracle instant client devel'
wget -nv https://www.dropbox.com/s/qjwbk0agc1rqxob/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm

echo 'Install oracle instant basic'
sudo alien -i oracle-instantclient*-basic-*.rpm

echo 'Install oracle instant devel'
sudo alien -i oracle-instantclient*-devel-*.rpm

# It installed to:
# /usr/lib/oracle/12.1/client64
# /usr/lib/oracle/12.1/client64/lib
sudo sh -c 'echo "env[ORACLE_HOME] = /usr/lib/oracle/12.1/client64" >> /etc/php/7.0/fpm/pool.d/www.conf'
sudo sh -c 'echo "env[ORACLE_HOME] = /usr/lib/oracle/12.1/client64" >> /etc/php/7.1/fpm/pool.d/www.conf'
sudo sh -c 'echo "env[ORACLE_HOME] = /usr/lib/oracle/12.1/client64" >> /etc/php/7.2/fpm/pool.d/www.conf'
sudo sh -c 'echo "env[LD_LIBRARY_PATH] = /usr/lib/oracle/12.1/client64/lib" >> /etc/php/7.0/fpm/pool.d/www.conf'
sudo sh -c 'echo "env[LD_LIBRARY_PATH] = /usr/lib/oracle/12.1/client64/lib" >> /etc/php/7.1/fpm/pool.d/www.conf'
sudo sh -c 'echo "env[LD_LIBRARY_PATH] = /usr/lib/oracle/12.1/client64/lib" >> /etc/php/7.2/fpm/pool.d/www.conf'
sudo service php7.0-fpm restart
sudo service php7.1-fpm restart
sudo service php7.2-fpm restart

echo 'install oci8'
printf "\n" | sudo pecl install oci8

echo 'add oci8 extension to php.ini'
sudo sh -c 'echo "extension=oci8.so" >> /etc/php/7.0/fpm/php.ini'
sudo sh -c 'echo "extension=oci8.so" >> /etc/php/7.1/fpm/php.ini'
sudo sh -c 'echo "extension=oci8.so" >> /etc/php/7.2/fpm/php.ini'

sudo service php7.0-fpm restart
sudo service php7.1-fpm restart
sudo service php7.2-fpm restart

sudo rm -rf ~/downloads