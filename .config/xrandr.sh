#!/usr/bin/env bash

function setScreens() {
 xrandr --newmode "1920x1080_75.00"  220.75  1920 2064 2264 2608  1080 1083 1088 1130 -hsync +vsync && xrandr --addmode HDMI2 1920x1080_75.00 && xrandr --output HDMI2 --mode "1920x1080_75.00" --primary --right-of eDP1
}

setScreens

#if [ "${GDMSESSION}" != 'spectrwm' ]
#then
#    setScreens
#fi
