#!/usr/bin/env bash

homesteadRoot=~/.homestead

mkdir -p "$homesteadRoot"

cp -i src/stubs/Homestead.yaml "$homesteadRoot/Homestead.yaml"
cp -i src/stubs/after.sh "$homesteadRoot/after.sh"
cp -i src/stubs/aliases "$homesteadRoot/aliases"
cp -i src/stubs/before.sh "$homesteadRoot/before.sh"

echo "Homestead initialized!"
