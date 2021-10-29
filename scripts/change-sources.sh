#!/usr/bin/env bash

new_sources="$1"
old_sources="http://archive.ubuntu.com"
if [[ -f /home/vagrant/.homestead-features/sources ]]; then
    old_sources=$(cat /home/vagrant/.homestead-features/sources)
fi

if [[ "$old_sources" != "$new_sources" ]]; then
    touch /home/vagrant/.homestead-features/sources
    echo "$new_sources" > /home/vagrant/.homestead-features/sources
    chown -Rf vagrant:vagrant /home/vagrant/.homestead-features

    sudo find /etc/apt -name 'sources.list' | xargs perl -pi -e "s|$old_sources|$new_sources|g"

    sudo apt-get update
fi
