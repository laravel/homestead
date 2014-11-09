#!/usr/bin/env bash

# Flush Firewall Rules
echo \> Flushing firewall rules...
sudo ipfw -q -f flush

# Adding virtual hosts
echo \> Removing virtual hosts...
bash vmhosts.sh remove

# Destroy VM
echo \> Destroying virtual machine...
vagrant destroy -f
