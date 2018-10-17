#!/usr/bin/env bash


DEFAULT_KEY='~/.ssh/id_rsa'
DEFAULT_AUTHORIZE='~/.ssh/id_rsa.pub'
DEFAULT_FOLDER='~/code'


cd `dirname $0`

key=$DEFAULT_KEY
echo -n "インストールに利用する秘密鍵を指定 (default: ${key}) : "
read key
if [ "$key" = '' ]
then
    key=$DEFAULT_KEY
fi

echo -n "インストールに利用する公開鍵を指定 (default: ${key}.pub) : "
read authorize
if [ "$authorize" = '' ]
then
    authorize=${key}.pub
fi

folder=$DEFAULT_FOLDER
echo -n "atls, atls_school 等含むプロダクトディレクトリを指定 (default: ${folder}) : "
read folder
if [ "$folder" = '' ]
then
    folder=$DEFAULT_FOLDER
fi


# ./init.sh with replacing variables
cat << EOS | while read command
cp -f resources/Homestead.yaml Homestead.yaml
cp -f resources/after.sh after.sh
cp -f resources/aliases aliases
perl -i -pe "s;${DEFAULT_AUTHORIZE}\\\n;${authorize}\\\n;g" Homestead.yaml
perl -i -pe "s;${DEFAULT_KEY}\\\n;${key}\\\n;g" Homestead.yaml
perl -i -pe "s;${DEFAULT_FOLDER}\\\n;${folder}\\\n;g" Homestead.yaml
EOS
do
    echo $command
    bash -c "$command"
done

echo "Homestead initialized!"


# notice git clone
if [ ! -d `bash -c "echo $folder/atls"` ]
then
    echo -e "\033[36;40;1mTODO: cd $folder; git clone {atls リポジトリ}\033[m"
fi

if [ ! -d `bash -c "echo $folder/atls_school"` ]
then
    echo -e "\033[36;40;1mTODO: cd $folder; git clone {atls_school リポジトリ}\033[m"
fi

if [ ! -d `bash -c "echo $folder/atls_cam_api"` ]
then
    echo -e "\033[36;40;1mTODO: cd $folder; git clone {atls_cam_api リポジトリ}\033[m"
fi


