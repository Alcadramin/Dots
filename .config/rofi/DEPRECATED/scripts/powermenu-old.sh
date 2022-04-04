#!/usr/bin/env bash

##
# Author: alcadramin <hello@berkcan.me>
# Github: @alcadramin
# Gitlab: @alcadramin
# Reddit: @panlazy
#
# License: MIT

dir="~/.config/rofi/themes/navy-and-ivory"
uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi -theme $dir/powermenu.rasi"

# Options
shutdown="  Shutdown"
reboot="  Restart"
lock="  Lock"
suspend="  Suspend"
logout="  Logout"

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "  Uptime: $uptime" -dmenu -selected-row 0)"
case $chosen in
$shutdown)
    systemctl poweroff
    ;;
$reboot)
    systemctl reboot
    ;;
$lock)
    betterlockscreen -l
    ;;
$suspend)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    systemctl suspend
    ;;
$logout)
    i3-msg exit
    ;;
esac
