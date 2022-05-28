#!/bin/bash
# baraction.sh for spectrwm status bar

## KERNEL
kernel() {
    kernel=`uname -r`
    echo -e "$kernel"
}

## DISK
hdd() {
  hdd="$(df -h | awk 'NR==4{print $3, $5}')"
  echo -e "HDD: $hdd"
}

## RAM
mem() {
  mem=`free | awk '/Mem/ {printf "%dM/%dM\n", $3 / 1024.0, $2 / 1024.0 }'`
  echo -e "$mem"
}

## CPU
cpu() {
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  echo -e "CPU: $cpu%"
}

## VOLUME
vol() {
    vol=`amixer -c 1 -M -D pulse get Master | awk -F'[][]' 'END{ print $4":"$2 }' | sed 's/on://g'`
    echo -e "VOL: $vol"
}

## WIFI
wifi(){
    wifi=`/sbin/iw dev | grep ssid | awk '{print $2}'`
    echo -e "$wifi"
}

# INTERNET CONNECTION
net() {
  if cat /sys/class/net/enp3s0/operstate | grep -q 'up'; then
    echo "ﯱ Online - enp3s0"
  elif cat /sys/class/net/wlp2s0/operstate | grep -q 'up'; then
    echo " Online - wlp2s0"
  else
    echo " Offline"
  fi
}

## KEYBOARD LAYOUT
layout(){
    layout=`setxkbmap -query | grep layout | awk '{print $2}'`
    echo -e "$layout"
}

SLEEP_SEC=0.5
while :; do
    # With disk & wifi
    #echo "+@fg=5; $(kernel)+@fg=0; | +@fg=6; $(cpu)+@fg=0; | +@fg=2;  $(mem)+@fg=0; | +@fg=3; $(hdd)+@fg=0; | +@fg=4; $(vol)+@fg=0; | +@fg=6;  $(wifi)+@fg=0; | +@fg=2; $(layout)+@fg=0; | +@fg=5;"

    # Without disk & network conf
    echo "+@fg=5; $(kernel)+@fg=0; | +@fg=6; $(cpu)+@fg=0; | +@fg=2; $(mem)+@fg=0; | +@fg=4; $(vol)+@fg=0; | +@fg=6;$(net)+@fg=0; | +@fg=2; $(layout)+@fg=0; | +@fg=5;"
	sleep $SLEEP_SEC
done
