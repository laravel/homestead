#!/usr/bin/env bash

# Forward Port 8000 (Guest) to 80 (Host)
echo \> Setting up firewall rules...
sudo ipfw -q -f flush
sudo ipfw -q -f add 100 fwd 127.0.0.1,8000 tcp from any to me 80

# Adding virtual hosts
echo \> Adding virtual hosts...
bash vmhosts.sh

# Boot VM
echo \> Booting up Homestead...
vagrant up
