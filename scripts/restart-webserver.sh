#!/usr/bin/env bash

# Restart whichever web server isn't disabled

# is nginx enabled?
OUTPUT="$(systemctl is-enabled nginx)"

if [ "$OUTPUT" == "enabled" ]; then
    service nginx restart
else
    service nginx stop
    service apache2 restart
fi
