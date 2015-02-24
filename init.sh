#!/usr/bin/env bash

mkdir -p ~/.homestead

cp src/stubs/Homestead.yaml ~/.homestead/Homestead.yaml
cp src/stubs/after.sh ~/.homestead/after.sh
cp src/stubs/aliases ~/.homestead/aliases

# Install hostsupdater to automatically add hosts to /etc/hosts or C:\Windows\System32\drivers\etc\hosts
vagrant plugin install vagrant-hostsupdater

echo "Homestead initialized!"
