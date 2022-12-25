#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/trader ]
then
    echo "Trader PHP extension already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/trader

# Update PECL Channel
sudo pecl channel-update pecl.php.net

# Install Trader Extension
sudo pecl install trader

sudo cp /usr/lib/php/20210902/trader.so /usr/lib/php/20131226/trader.so
sudo cp /usr/lib/php/20210902/trader.so /usr/lib/php/20151012/trader.so
sudo cp /usr/lib/php/20210902/trader.so /usr/lib/php/20160303/trader.so
sudo cp /usr/lib/php/20210902/trader.so /usr/lib/php/20170718/trader.so
sudo cp /usr/lib/php/20210902/trader.so /usr/lib/php/20180731/trader.so
sudo cp /usr/lib/php/20210902/trader.so /usr/lib/php/20200930/trader.so

sudo touch /etc/php/8.1/mods-available/trader.ini
sudo bash -c 'echo "extension=trader.so" >> /etc/php/8.1/mods-available/trader.ini'
sudo ln -s /etc/php/8.1/mods-available/trader.ini /etc/php/8.1/fpm/conf.d/20-trader.ini
sudo ln -s /etc/php/8.1/mods-available/trader.ini /etc/php/8.1/cgi/conf.d/20-trader.ini
sudo ln -s /etc/php/8.1/mods-available/trader.ini /etc/php/8.1/cli/conf.d/20-trader.ini
sudo ln -s /etc/php/8.1/mods-available/trader.ini /etc/php/8.1/phpdbg/conf.d/20-trader.ini

sudo touch /etc/php/8.0/mods-available/trader.ini
sudo bash -c 'echo "extension=trader.so" >> /etc/php/8.0/mods-available/trader.ini'
sudo ln -s /etc/php/8.0/mods-available/trader.ini /etc/php/8.0/fpm/conf.d/20-trader.ini
sudo ln -s /etc/php/8.0/mods-available/trader.ini /etc/php/8.0/cgi/conf.d/20-trader.ini
sudo ln -s /etc/php/8.0/mods-available/trader.ini /etc/php/8.0/cli/conf.d/20-trader.ini
sudo ln -s /etc/php/8.0/mods-available/trader.ini /etc/php/8.0/phpdbg/conf.d/20-trader.ini

sudo touch /etc/php/7.4/mods-available/trader.ini
sudo bash -c 'echo "extension=trader.so" >> /etc/php/7.4/mods-available/trader.ini'
sudo ln -s /etc/php/7.4/mods-available/trader.ini /etc/php/7.4/fpm/conf.d/20-trader.ini
sudo ln -s /etc/php/7.4/mods-available/trader.ini /etc/php/7.4/cgi/conf.d/20-trader.ini
sudo ln -s /etc/php/7.4/mods-available/trader.ini /etc/php/7.4/cli/conf.d/20-trader.ini
sudo ln -s /etc/php/7.4/mods-available/trader.ini /etc/php/7.4/phpdbg/conf.d/20-trader.ini

sudo touch /etc/php/7.3/mods-available/trader.ini
sudo bash -c 'echo "extension=trader.so" >> /etc/php/7.3/mods-available/trader.ini'
sudo ln -s /etc/php/7.3/mods-available/trader.ini /etc/php/7.3/fpm/conf.d/20-trader.ini
sudo ln -s /etc/php/7.3/mods-available/trader.ini /etc/php/7.3/cgi/conf.d/20-trader.ini
sudo ln -s /etc/php/7.3/mods-available/trader.ini /etc/php/7.3/cli/conf.d/20-trader.ini
sudo ln -s /etc/php/7.3/mods-available/trader.ini /etc/php/7.3/phpdbg/conf.d/20-trader.ini

sudo touch /etc/php/7.2/mods-available/trader.ini
sudo bash -c 'echo "extension=trader.so" >> /etc/php/7.2/mods-available/trader.ini'
sudo ln -s /etc/php/7.2/mods-available/trader.ini /etc/php/7.2/fpm/conf.d/20-trader.ini
sudo ln -s /etc/php/7.2/mods-available/trader.ini /etc/php/7.2/cgi/conf.d/20-trader.ini
sudo ln -s /etc/php/7.2/mods-available/trader.ini /etc/php/7.2/cli/conf.d/20-trader.ini
sudo ln -s /etc/php/7.2/mods-available/trader.ini /etc/php/7.2/phpdbg/conf.d/20-trader.ini

sudo touch /etc/php/7.1/mods-available/trader.ini
sudo bash -c 'echo "extension=trader.so" >> /etc/php/7.1/mods-available/trader.ini'
sudo ln -s /etc/php/7.1/mods-available/trader.ini /etc/php/7.1/fpm/conf.d/20-trader.ini
sudo ln -s /etc/php/7.1/mods-available/trader.ini /etc/php/7.1/cgi/conf.d/20-trader.ini
sudo ln -s /etc/php/7.1/mods-available/trader.ini /etc/php/7.1/cli/conf.d/20-trader.ini
sudo ln -s /etc/php/7.1/mods-available/trader.ini /etc/php/7.1/phpdbg/conf.d/20-trader.ini

sudo touch /etc/php/7.0/mods-available/trader.ini
sudo bash -c 'echo "extension=trader.so" >> /etc/php/7.0/mods-available/trader.ini'
sudo ln -s /etc/php/7.0/mods-available/trader.ini /etc/php/7.0/fpm/conf.d/20-trader.ini
sudo ln -s /etc/php/7.0/mods-available/trader.ini /etc/php/7.0/cgi/conf.d/20-trader.ini
sudo ln -s /etc/php/7.0/mods-available/trader.ini /etc/php/7.0/cli/conf.d/20-trader.ini
sudo ln -s /etc/php/7.0/mods-available/trader.ini /etc/php/7.0/phpdbg/conf.d/20-trader.ini

sudo touch /etc/php/5.6/mods-available/trader.ini
sudo bash -c 'echo "extension=trader.so" >> /etc/php/5.6/mods-available/trader.ini'
sudo ln -s /etc/php/5.6/mods-available/trader.ini /etc/php/5.6/fpm/conf.d/20-trader.ini
sudo ln -s /etc/php/5.6/mods-available/trader.ini /etc/php/5.6/cgi/conf.d/20-trader.ini
sudo ln -s /etc/php/5.6/mods-available/trader.ini /etc/php/5.6/cli/conf.d/20-trader.ini
sudo ln -s /etc/php/5.6/mods-available/trader.ini /etc/php/5.6/phpdbg/conf.d/20-trader.ini
