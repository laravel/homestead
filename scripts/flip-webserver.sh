#!/usr/bin/env bash

ps auxw | grep apache2 | grep -v grep > /dev/null

if [ $? != 0 ]
then
    service nginx stop > /dev/null
    echo 'nginx stopped'
    service apache2 start > /dev/null
    echo 'apache started'
else
    service apache2 stop > /dev/null
    echo 'apache stopped'
    service nginx start > /dev/null
    echo 'nginx started'
fi
