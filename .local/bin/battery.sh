#!/usr/bin/env bash

for battery in /sys/class/power_supply/BAT?*; do
	# If non-first battery, print a space separator.
	[ -n "${capacity+x}" ] && printf " "
	# Sets up the status and capacity
	case "$(cat "$battery/status" 2>/dev/null)" in
		"Full") status=" " ;;
		"Discharging") status=" " ;;
		"Charging") status=" " ;;
		"Not charging") status=" " ;;
		"Unknown") status=" " ;;
	esac
	capacity=$(cat "$battery/capacity" 2>/dev/null)
	# Will make a warn variable if discharging and low
	[ "$status" = " " ] && [ "$capacity" -le 25 ] && notify-send --urgency=critical "System Management" "Battery low."
	# Prints the info
	echo "$status$capacity"
done && exit 0
