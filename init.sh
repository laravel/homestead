#!/usr/bin/env bash

mkdir -p ~/.homestead

homesteadRoot=~/.homestead

yaml=$homesteadRoot/Homestead.yaml
after=$homesteadRoot/after.sh
aliases=$homesteadRoot/aliases

if [ -f $yaml ]; then
	echo "$yaml found, not overwriting it!"
else
	cp src/stubs/Homestead.yaml $yaml
fi;

if [ -f $after ]; then
	echo "$after found, not overwriting it!"
else
	cp src/stubs/after.sh $after
fi;

if [ -f $aliases ]; then
	echo "$aliases found, not overwriting it!"
else
	cp src/stubs/aliases $aliases
fi;

echo "Homestead initialized!"
