#!/usr/bin/env bash

setxkbmap -query | grep layout | awk '{print $2}'

