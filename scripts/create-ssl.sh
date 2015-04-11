#!/usr/bin/env bash

[ -d /etc/nginx/ssl ] || sudo mkdir /etc/nginx/ssl && sudo cp /vagrant/src/stubs/nginx.* /etc/nginx/ssl