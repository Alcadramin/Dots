#!/usr/bin/env bash

[ $(pamixer --get-mute) = true ] && echo 婢 && exit

vol="$(pamixer --get-volume)"

if [ "$vol" -gt "70" ]; then
  icon=" "
elif [ "$vol" -lt "30" ]; then
  icon="奔 "
else
  icon="墳 "
fi

echo "$icon$vol%"
