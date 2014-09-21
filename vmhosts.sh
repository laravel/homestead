#!/usr/bin/env bash

# Path to Hosts
HOSTS='/etc/hosts'

# Remove existing virtual hosts
sed '/# Homestead/,/# End/d' ${HOSTS} | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' > hosts.tmp

if [ "$1" = "remove" ]; then
   	sudo mv hosts.tmp ${HOSTS} 
   	exit
fi

# Add Virtual Hosts to /etc/Hosts
cat >> hosts.tmp <<EOF


# Homestead Virtual Hosts
#
# These hosts are managed by Homestead. Use 'vmedit' to edit them.
# Do NOT modify the following hosts manually.

EOF
cat Homestead.yaml | grep 'map.*\.' | sed s/.*\ /127.0.0.1\	/g >> hosts.tmp
cat >> hosts.tmp <<EOF

# End
EOF
sudo mv hosts.tmp ${HOSTS}
