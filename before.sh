#!/bin/sh

token="`cat github-personal-access-token.txt`"
echo '{"github-oauth": {"github.com": "'"$token"'"}}' > /home/vagrant/.composer/auth.json
