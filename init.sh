#!/usr/bin/env bash

mkdir -p ~/.homestead

yaml=~/.homestead/Homestead.yaml

if [ -f $yaml ]; then
	echo "$yaml found, not overwriting it!"
else
	cp src/stubs/Homestead.yaml $yaml
fi;
cp src/stubs/after.sh ~/.homestead/after.sh
cp src/stubs/aliases ~/.homestead/aliases

echo "Homestead initialized!"
