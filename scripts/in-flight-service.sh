#!/usr/bin/env bash
# scripts/in-flight-service.sh
# this script is solely for doing questionable things to update the base OS
# Without having to ship an entirely new base box.

# Fix expired certs: https://github.com/laravel/homestead/issues/1707
# sudo rm -rf /usr/share/ca-certificates/mozilla/DST_Root_CA_X3.crt
# sudo update-ca-certificates
