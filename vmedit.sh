#!/usr/bin/env bash

# Choose your default editor
EDITOR='sublime -w'

# Edit Homestead.yaml
echo \> Opening configuration file...
eval $EDITOR Homestead.yaml

# Check if Homestead.yaml was edited...
if [[ -n $(find . -name Homestead.yaml -mtime -60s) ]]
then
	# If True...
	if [[ -n $(vagrant status | grep 'running') ]]
	then
		# Add Virtual Hosts to /etc/hosts
		echo \> Reseting virtual hosts...
		bash vmhosts.sh

		# Provision Machine
		echo \> Provisioning machine...
		vagrant provision
	fi
fi
