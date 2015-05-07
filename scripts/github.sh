#!/usr/bin/env bash

TOKEN=$1;

su vagrant -c "composer config --global github-oauth.github.com \"$TOKEN\""