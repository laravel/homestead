#!/usr/bin/env bash

# Add new IP-host pair to /etc/hosts.

if [[ "$1" && "$2" ]]
then
    IP=$1
    HOSTNAME=$2

    if [ -n "$(grep [^\.]$HOSTNAME /etc/hosts)" ]
        then
            echo "$HOSTNAME already exists:";
            echo $(grep [^\.]$HOSTNAME /etc/hosts);
        else
            sudo sed -i "/#### HOMESTEAD-SITES-BEGIN/c\#### HOMESTEAD-SITES-BEGIN\\n$IP\t$HOSTNAME" /etc/hosts

            if ! [ -n "$(grep [^\.]$HOSTNAME /etc/hosts)" ]
                then
                    echo "Failed to Add $HOSTNAME, Try again!";
            fi
    fi
else
    echo "Error: missing required parameters."
    echo "Usage: "
    echo "  addhost ip domain"
fi
