#!/usr/bin/env bash

mkdir -p ~/.homestead

homesteadRoot=~/.homestead

cp -i src/stubs/Homestead.yaml "$homesteadRoot/Homestead.yaml"
cp -i src/stubs/after.sh "$homesteadRoot/after.sh"
cp -i src/stubs/aliases "$homesteadRoot/aliases"

echo "Homestead initialized!"
