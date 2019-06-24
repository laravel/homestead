#!/usr/bin/env bash
#
# Check if web server is running and if not restart it.
# In case some site setting required mount directories to be present and made it unable to start

systemctl is-active --quiet nginx.service
result=$?

if [ ${result} != "0" ]
    then
        systemctl restart nginx.service
        echo "Server restarted.";
    else
        echo "Server running.";
fi