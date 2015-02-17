#!/usr/bin/env bash

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

# Populate this array with each of your dev site hostnames.
# This could be pulled from Homestead.yaml somehow.
sites_hosts=( host_name_of_site1 ) # array, e.g., www.example.dev

# Save our Homestead.yaml mapped folder to a var.
scripts_dir="/home/vagrant/homestead"

# Config for SSL.
echo "--- Making SSL Directory ---"
mkdir /etc/nginx/ssl

for i in "${sites_hosts[@]}"
do
    echo "--- Copying $i SSL crt and key ---"
    cp $scripts_dir/ssl/$i.crt /etc/nginx/ssl/$i.crt
    cp $scripts_dir/ssl/$i.key /etc/nginx/ssl/$i.key

    echo "--- Turning SSL on in nginx.conf. ---"
    # Comment out this line if you prefer ssl on a per
    # server basis, rather for all sites on the vm.
    # If commented out you can access hosts on http
    # port 8000, and https port 44300. If uncommented,
    # you can ONLY access hosts via https on port 44300.
    sed -i "/sendfile on;/a \\        ssl on;" /etc/nginx/nginx.conf

    echo "--- Inserting SSL directives into site's server file. ---"
    sed -i "/listen 80;/a \\\n    listen 443 ssl;\n    ssl_certificate /etc/nginx/ssl/$i.crt;\n    ssl_certificate_key /etc/nginx/ssl/$i.key;\n\n" /etc/nginx/sites-available/$i

done

echo "--- Restarting Serivces ---"
service nginx restart
service hhvm restart
