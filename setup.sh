#!/usr/bin/env bash

format_help="  %-20s\t%-54s\n"
bold=$(tput bold)
color=$(tput setaf 3)
normal=$(tput sgr0)
arrow="${color}${bold}=>${normal}"
function _help() {
  echo "Berkcan Ucan (alcadramin) <hello@alca.dev>"
  echo "${bold}Description:${normal} This script will help you to setup your environment and load dotfiles as well as create a backup."
  echo ""
  echo "${bold}USAGE: ${normal}"
  echo "    sh -e setupEnvironment.sh [FLAGS] or ./setupEnvironment [FLAGS]"
  echo ""
  echo "${bold}FLAG: ${normal}"
  printf "${format_help}" \
    "-h, --help, help" "Print this help message" \
    "-i, --install, help" "Install required applications and copy dotfiles (AUR helper is required for Arch based distributions)" \
    "-b, --backup, backup" "Copy local dotfiles to this directory"
}

function _init() {
  echo " _             _____"
  echo "| |           |____ |"
  echo "| |____      __   / /_   _"
  echo "| '_ \ \ /\ / /   \ \ | | |"
  echo "| |_) \ V  V /.___/ / |_| |"
  echo "|_.__/ \_/\_/ \____/ \__,_|"
  echo ""
  echo "${arrow} Starting script.."

}

function _install() {
  local OS=$(awk -F'"' '/NAME/ {print $2; exit}' /etc/os-release)

  if command -v paru &>/dev/null; then
    echo "${arrow} Your OS: $OS - Arch Based Distribution (paru)"
    echo "${arrow} Starting installation.."
    withParu
  elif command -v yay &>/dev/null; then
    echo "${arrow} Your OS: $OS - Arch Based Distribution (yay)"
    echo "${arrow} Starting installation.."
    withYay
  elif command -v apt &>/dev/null; then
    echo "${arrow} Your OS: $OS - Debian Based Distribution (apt)"
    echo "${arrow} Starting installation.."
    withApt
  else
    echo "${arrow} Could not detect your OS, can't install applications. Exiting.."
    exit 1
  fi
}

function withParu() {
  echo "${arrow} Would you like to install utility apps? (picom, nitrogen, dmenu etc..): (yes/no)"
  read INSTALL_UTILITY

  if [[ $INSTALL_UTILITY == "yes" || $INSTALL_UTILITY == "y" ]]; then
    echo "${arrow} Installing utility apps.."

    /usr/bin/paru -S --skipreview rsync python psmisc xorg-xprop xorg-xwininfo ffmpeg wireless_tools amazon-corretto-11 \
      pulseaudio pulseaudio-alsa alsa-utils brightnessctl nitrogen gnome-calendar dmenu rofi xfce4-power-manager \
      lxappearance lxsession xautolock xclip flameshot jome-git volumeicon xfce4-notifyd polkit-gnome ffmpegthumbnailer \
      tumbler viewnior mpv mpd mpc ncmpcpp trayer network-manager-applet pavucontrol parcellite neofetch htop picom-git gtk2-perl playerctl xsettingsd
  else
    echo "${arrow} You chose: ${INSTALL_UTILITY}"
  fi

  echo "${arrow} Copying dotfiles.."

  rsync -avxRHAXP .oh-my-zsh/ .config/picom/ .zshrc .Xresources ~/

  echo "${arrow} Let's check if I am running the script, will copy personal stuff (gitconfig etc.). Are you ${bold}alcadramin${normal}? (yes/no)"
  read alcadramin

  if [[ $alcadramin == "yes" || $alcadramin == "y" ]]; then
    echo "${arrow} Copying personal stuff.."
    rsync -avxRHAXP .gitconfig .xprofile .config/xrandr.sh .profile ~/
  fi

  echo "${arrow} Would you like to install window manager and setup the dotfiles? (yes/no)"
  read INSTALL_WM

  if [[ $INSTALL_WM == "yes" || $INSTALL_WM == "y" ]]; then
    windowManager paru
  else
    echo "${arrow} You chose: ${INSTALL_WM}"
  fi

  echo "${arrow} Would you like to install terminal emulator and setup the dotfiles? (yes/no)"
  read INSTALL_WM

  if [[ $INSTALL_WM == "yes" || $INSTALL_WM == "y" ]]; then
    terminalEmulator paru
  else
    echo "${arrow} You chose: ${INSTALL_WM}"
  fi
}

function withYay() {
  echo "${arrow} Would you like to install utility apps? (picom, nitrogen, dmenu etc..): (yes/no)"
  read INSTALL_UTILITY

  if [[ $INSTALL_UTILITY == "yes" || $INSTALL_UTILITY == "y" ]]; then
    echo "${arrow} Installing utility apps.."

    /usr/bin/yay -S --skipreview rsync python psmisc xorg-xprop xorg-xwininfo ffmpeg wireless_tools amazon-corretto-11 \
      pulseaudio pulseaudio-alsa alsa-utils brightnessctl nitrogen gnome-calendar dmenu rofi xfce4-power-manager \
      lxappearance lxsession xautolock xclip flameshot jome-git volumeicon xfce4-notifyd polkit-gnome ffmpegthumbnailer \
      tumbler viewnior mpv mpd mpc ncmpcpp trayer network-manager-applet pavucontrol parcellite neofetch htop picom-git gtk2-perl playerctl xsettingsd
  else
    echo "${arrow} You chose: ${INSTALL_UTILITY}"
  fi

  rsync -avxRHAXP .oh-my-zsh/ .config/picom/ .zshrc .Xresources ~/

  echo "${arrow} Let's check if I am running the script, will copy personal stuff (gitconfig etc.). Are you ${bold}alcadramin${normal}? (yes/no)"
  read alcadramin

  if [[ $alcadramin == "yes" || $alcadramin == "y" ]]; then
    echo "${arrow} Copying personal stuff.."
    rsync -avxRHAXP .gitconfig .xprofile .config/xrandr.sh .profile ~/
  fi

  echo "${arrow} Would you like to install window manager and setup the dotfiles? (yes/no)"
  read INSTALL_WM

  if [[ $INSTALL_WM == "yes" || $INSTALL_WM == "y" ]]; then
    windowManager yay
  else
    echo "${arrow} You chose: ${INSTALL_WM}"
  fi

  echo "${arrow} Would you like to install terminal emulator and setup the dotfiles? (yes/no)"
  read INSTALL_WM

  if [[ $INSTALL_WM == "yes" || $INSTALL_WM == "y" ]]; then
    terminalEmulator yay
  else
    echo "${arrow} You chose: ${INSTALL_WM}"
  fi
}

function withApt() {
  echo "${arrow} Would you like to install utility apps? (picom, nitrogen, dmenu etc..): (yes/no)"
  read INSTALL_UTILITY

  if [[ $INSTALL_UTILITY == "yes" || $INSTALL_UTILITY == "y" ]]; then
    echo "${arrow} Installing utility apps.."

    /usr/bin/sudo /usr/bin/apt install --skipreview rsync python psmisc x11-utils ffmpeg wireless_tools \
      pulseaudio alsa-utils brightnessctl nitrogen gnome-calendar dmenu rofi xfce4-power-manager \
      lxappearance lxpolkit xautolock xclip flameshot volumeicon xfce4-notifyd ffmpegthumbnailer \
      tumbler viewnior mpv mpd mpc ncmpcpp trayer network-manager-gnome pavucontrol parcellite neofetch htop picom gtk2-perl playerctl xsettingsd
  else
    echo "${arrow} You chose: ${INSTALL_UTILITY}"
  fi

  rsync -avxRHAXP .oh-my-zsh/ .config/picom/ .zshrc .Xresources ~/

  echo "${arrow} Let's check if I am running the script, will copy personal stuff (gitconfig etc.). Are you ${bold}alcadramin${normal}? (yes/no)"
  read alcadramin

  if [[ $alcadramin == "yes" || $alcadramin == "y" ]]; then
    echo "${arrow} Copying personal stuff.."
    rsync -avxRHAXP .gitconfig .xprofile .config/xrandr.sh .profile ~/
  fi

  echo "${arrow} Would you like to install window manager and setup the dotfiles? (yes/no)"
  read INSTALL_WM

  if [[ $INSTALL_WM == "yes" || $INSTALL_WM == "y" ]]; then
    windowManager apt
  else
    echo "${arrow} You chose: ${INSTALL_WM}"
  fi

  echo "${arrow} Would you like to install terminal emulator and setup the dotfiles? (yes/no)"
  read INSTALL_WM

  if [[ $INSTALL_WM == "yes" || $INSTALL_WM == "y" ]]; then
    terminalEmulator apt
  else
    echo "${arrow} You chose: ${INSTALL_WM}"
  fi
}

function windowManager() {
  pkgMan=$1

  HEIGHT=15
  WIDTH=40
  CHOICE_HEIGHT=4
  BACKTITLE="Window Manager"
  TITLE="Which window manager would you like to install?"
  MENU="Choose one of the following options:"

  OPTIONS=(1 "Xmonad with Xmobar"
    2 "Qtile"
    3 "Spectrwm")

  CHOICE=$(dialog --clear \
    --backtitle "$BACKTITLE" \
    --title "$TITLE" \
    --menu "$MENU" \
    $HEIGHT $WIDTH $CHOICE_HEIGHT \
    "${OPTIONS[@]}" \
    2>&1 >/dev/tty)

  clear
  case $CHOICE in
  1)
    echo "${arrow} You chose Xmonad & Xmobar.. Starting installation and copying dotfiles & themes.."

    if [[ $pkgMan == "apt" ]]; then
      /usr/bin/sudo /usr/bin/$pkgMan install xmonad xmonad-contrib xmobar
    else
      /usr/bin/$pkgMan -S xmonad xmonad-contrib xmobar
    fi

    rsync -avxRHAXP .xmonad/ .config/xmobar/ .themes/ .local/ ~/
    echo "${arrow} Job completed. Please edit dotfiles accordingly to your system. You can run this script again to install other WM's.."
    exit 1
    ;;
  2)
    echo "You chose Qtile.. Starting installation and copying dotfiles & themes.."

    if [[ $pkgMan == "apt" ]]; then
      /usr/bin/sudo /usr/bin/$pkgMan install qtile
    else
      /usr/bin/$pkgMan -S qtile
    fi

    rsync -avxRHAXP .config/qtile/ .themes/ .local/ ~/
    echo "${arrow} Job completed. Please edit dotfiles accordingly to your system. You can run this script again to install other WM's.."
    exit 1
    ;;
  3)
    echo "You chose Spectrwm.. Starting installation and copying dotfiles & themes.."

    if [[ $pkgMan == "apt" ]]; then
      /usr/bin/sudo /usr/bin/$pkgMan install spectrwm
    else
      /usr/bin/$pkgMan -S spectrwm
    fi

    rsync .spectrwm.conf baraction.sh ~/
    echo "${arrow} Job completed. Please edit dotfiles accordingly to your system. You can run this script again to install other WM's.."
    exit 1
    ;;
  *)
    echo "${arrow} Exiting.."
    exit 1
    ;;
  esac
}

function terminalEmulator() {
  pkgMan=$1

  HEIGHT=15
  WIDTH=40
  CHOICE_HEIGHT=4
  BACKTITLE="Terminal Emulator"
  TITLE="Which terminal emulator would you like to install?"
  MENU="Choose one of the following options:"

  OPTIONS=(1 "Alacritty"
    2 "Termite")

  CHOICE=$(dialog --clear \
    --backtitle "$BACKTITLE" \
    --title "$TITLE" \
    --menu "$MENU" \
    $HEIGHT $WIDTH $CHOICE_HEIGHT \
    "${OPTIONS[@]}" \
    2>&1 >/dev/tty)

  clear
  case $CHOICE in
  1)
    echo "${arrow} You chose Alacritty.. Starting installation and copying dotfiles.."

    if [[ $pkgMan == "apt" ]]; then
      /usr/bin/sudo /usr/bin/$pkgMan install alacritty
    else
      /usr/bin/$pkgMan -S alacritty
    fi

    rsync -avxRHAXP .config/alacritty.yml ~/

    echo "${arrow} Job completed. Please edit dotfiles accordingly to your system. You can run this script again to install other terminal emulators.."
    exit 1
    ;;
  2)
    echo "You chose Termite.. Starting installation and copying dotfiles.."

    if [[ $pkgMan == "apt" ]]; then
      /usr/bin/sudo /usr/bin/$pkgMan install termite
    else
      /usr/bin/$pkgMan -S termite
    fi

    rsync -avxRHAXP .config/termite/ .local/ ~/
    echo "${arrow} Job completed. Please edit dotfiles accordingly to your system. You can run this script again to install other terminal emulators.."
    exit 1
    ;;
  *)
    echo "${arrow} Exiting.."
    exit 1
    ;;
  esac
}

function _backup() {
  echo "${arrow} Not implemented yet."
}

case "$#" in
0)
  _help
  ;;
1)
  case "$1" in
  -h | --help | help)
    _help
    ;;
  -i | --install | install)
    _init
    _install
    ;;
  -b | --backup | backup)
    _init
    _backup
    ;;
  *)
    echo "Input error."
    exit 1
    ;;
  esac
  ;;
*)
  echo "Input error, too many arguments."
  exit 1
  ;;
esac
