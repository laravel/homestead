#!/bin/sh

echo 'Installing Postfix...'

DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew" install -yq postfix

cp -f /vagrant/scripts-custom/configs/postfix.conf /etc/postfix/main.cf
chown root:root /etc/postfix/main.cf && chmod 644 /etc/postfix/main.cf

systemctl restart postfix
