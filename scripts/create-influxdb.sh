#!/usr/bin/env bash

influx -execute "create database $1"
