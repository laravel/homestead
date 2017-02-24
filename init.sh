#!/usr/bin/env bash

if [[ -n "$1" ]]; then
    cp -i src/stubs/Homestead.json Homestead.json
else
    cp -i src/stubs/Homestead.yaml Homestead.yaml
fi

cp -i src/stubs/after.sh after.sh
cp -i src/stubs/aliases aliases

echo "Homestead initialized!"
