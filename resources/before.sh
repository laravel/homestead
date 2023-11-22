#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run before the Homestead machine is configured.
#
# If you have user-specific configurations you would liketo apply,
# you may also create user-customizations-before.sh,
# which will be run after this script.


# If you'd like to use local mirrors instead of the default US mirrors
# uncomment these lines to add these to your sources.list

#cp /etc/apt/sources.list /etc/apt/sources.list.backup

#cat <<EOF | tee /etc/apt/sources.list
#deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs) main restricted universe multiverse
#deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs)-updates main restricted universe multiverse
#deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs)-backports main restricted universe multiverse
#deb mirror://mirrors.ubuntu.com/mirrors.txt $(lsb_release -cs)-security main restricted universe multiverse
#EOF

#apt-get update -y
