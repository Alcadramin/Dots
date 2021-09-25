#!/bin/sh

Shutdown_command="systemctl poweroff"
Reboot_command="systemctl reboot"
Logout_command="swaymsg exit"
Hibernate_command="systemctl hibernate"
Suspend_command="systemctl suspend"
Back_command=""

# you can customise the rofi command all you want ...
rofi_command="rofi -theme $HOME/.config/wofi/launcherSmoll.rasi"
options='  Back\n  Shutdown\n  Logout\n  Reboot\n鈴  Hibernate\n  Suspend' 

# ... because the essential options (-dmenu and -p) are added here
eval \$"$(echo "$options" | $rofi_command -dmenu -p "")_command"
