#!/usr/bin/env bash

mkdir -p ~/.homestead

cp src/stubs/Homestead.yaml ~/.homestead/Homestead.yaml
cp src/stubs/after.sh ~/.homestead/after.sh
cp src/stubs/aliases ~/.homestead/aliases

echo "Homestead initialized!"
