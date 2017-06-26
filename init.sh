#!/usr/bin/env bash

find files/* -type f -not -name ".gitkeep" -exec rm -f {} \;

if [[ -n "$1" ]]; then
    cp -i resources/Homestead.json files/Homestead.json
else
    cp -i resources/Homestead.yaml files/Homestead.yaml
fi

cp -i resources/after.sh files/after.sh
cp -i resources/aliases files/aliases
cp -i resources/custom/* files/custom/

echo "Homestead initialized!"
