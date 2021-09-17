#!/usr/bin/env bash

count=$(LANG=C apt-get upgrade -s |grep -P '^\d+ upgraded'|cut -d" " -f1 | wc -l)
echo "$count "
