#!/usr/bin/env bash

/usr/lib/xfce4/notifyd/xfce4-notifyd &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
picom -b &
nitrogen --restore &
volumeicon &
nm-applet &
xfce4-power-manager &
flameshot &
