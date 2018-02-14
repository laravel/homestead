#!/bin/sh

# Set the command line php to 7.1 due to current platform incompatibilities
sudo update-alternatives --set php /usr/bin/php7.1

# Set Github Token
read -p "Your Personal Github Access Token : " token
echo '{"github-oauth": {"github.com": "'"$token"'"}}' > /home/vagrant/.composer/auth.json

# Install Dependencies
cd /var/veromo
rm -rf vendor/
composer install

# Prepare DB
php app/console doctrine:schema:update --force

# Clear any old cache
php app/console cache:clear

# Add test data
php app/console veromo:schema:provision
php app/console veromo:batch:testaccounts
php app/console veromo:batch:testdata
