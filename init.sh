#!/usr/bin/env bash

find files/* -type f -not -name ".gitkeep" -exec rm -f {} \;

if [[ -n "$1" ]]; then
    cp -i resources/Homestead.json files/Homestead.json
else
    cp -i resources/Homestead.yaml files/Homestead.yaml
fi

#
## Check and set needed environment variables
#

if [[ -z "${HOMESTEAD_WORKING_DIR}" ]]; then
    read -e -p "Absolute path to your main code folder: " path

    export HOMESTEAD_WORKING_DIR=${path}
fi

if [[ -z "${HOMESTEAD_VENDOR_DIR}" ]]; then
    read -e -p "Absolute path to your Homestead vendor folder: " path

    export HOMESTEAD_VENDOR_DIR=${path}
fi

#
## Replace paths in Homestead config
#

sed -i -e "s{codeRepositoryPath}$HOMESTEAD_WORKING_DIRg" files/Homestead.yaml
sed -i -e "s{vendorPath}$HOMESTEAD_VENDOR_DIRg" files/Homestead.yaml


cp -i resources/after.sh files/after.sh
cp -i resources/aliases files/aliases
cp -i resources/custom/* files/custom/

echo "Homestead initialized!"
