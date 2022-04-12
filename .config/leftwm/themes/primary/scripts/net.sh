#!/usr/bin/env bash

HOSTNAME=$(hostname -I | awk '{print $1}')

if cat /sys/class/net/enp3s0/operstate | grep -q 'up'; then
  echo "$HOSTNAME - enp3s0"
elif cat /sys/class/net/wlp2s0/operstate | grep -q 'up'; then
  echo "$HOSTNAME - wlp2s0"
else
  echo "Offline"
fi
