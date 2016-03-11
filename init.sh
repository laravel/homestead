#!/usr/bin/env bash

# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables
homesteadRoot="${XDG_CONFIG_HOME:-$HOME/.config}/homestead"

mkdir -p "$homesteadRoot"

cp -i src/stubs/Homestead.yaml "$homesteadRoot/Homestead.yaml"
cp -i src/stubs/after.sh "$homesteadRoot/after.sh"
cp -i src/stubs/aliases "$homesteadRoot/aliases"

echo "Homestead initialized!"
