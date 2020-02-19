#!/bin/sh

echo 'Installing Dovecot...'

export DEBIAN_FRONTEND=noninteractive
apt-get -yq install dovecot-core dovecot-imapd

# Dovecot seems to need this directory, which seems odd, given that we're using
# mbox format via mail_location = mbox:/var/mail:INBOX=/var/mail/%u ... oh well.

mkdir -p /var/mail/.imap
chown vagrant:mail /var/mail/.imap
chmod o= /var/mail/.imap

# Send a test email, which forces the "vagrant" user's mailbox to be created
# with appropriate ownership and permissions (Dovecot will create it).

echo 'Subject: Welcome to Homestead!' | sendmail -v vagrant@homestead

cp /vagrant/scripts-custom/configs/dovecot.conf /etc/dovecot/local.conf
chown root:root /etc/dovecot/local.conf && chmod 644 /etc/dovecot/local.conf

systemctl restart dovecot
