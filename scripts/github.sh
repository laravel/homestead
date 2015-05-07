#!/usr/bin/env bash

TOKEN=$1;

composer config --global github-oauth.github.com "$TOKEN"
