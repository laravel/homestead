#!/usr/bin/env bash
#
# Runs virtual frame buffer

Xvfb -ac :0 -screen 0 1280x1024x16 &
