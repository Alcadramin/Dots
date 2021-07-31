#
### 🐈 Hello! Thank you for visiting. I keep my stuff here! <img alt="" align="right" src="https://flat.badgen.net/gitlab/stars/bw3u/dotfiles"/>

<a href="https://i.imgur.com/dyrSZLH.png">
  <img src="https://i.imgur.com/dyrSZLH.png" alt="minimal" align="right" width="400px"/>
</a>

This is my **personal configuration** for my favorite window managers and some applications.

Details of my setup..

- **Window Manager**               • [Xmonad](https://xmonad.org/), [qtile](http://www.qtile.org/), [spectrwm](https://github.com/conformal/spectrwm) 🎨
- **Shell**                        • [Zsh](https://www.zsh.org/) 🐚 with [oh my zsh](https://github.com/ohmyzsh/ohmyzsh) framework.
- **Terminal**                     • [Alacritty](https://github.com/alacritty/alacritty), [Termite](https://github.com/thestinger/termite) <kbd>available</kbd>.
- **Compositor**                   • [Picom](https://github.com/yshui/picom) 🍩 rounded corners and blur!
- **Application Launcher**         • [dmenu](https://tools.suckless.org/dmenu/) 🚀 blazing fast!
- **File Manager**                 • [PCManFM](https://wiki.lxde.org/en/PCManFM) 🔖 world's lighweight file manager!
- **Music Player**                 • [Spotify](https://www.spotify.com/us/download/linux/) 🍚 *riced!*
- **GUI & CLI IDE/Text Editor**    • [Kakoune](https://kakoune.org/), [Neovim](https://neovim.io/) and the big boy [Doom Emacs](https://github.com/hlissner/doom-emacs) 😈

#
### How to install? <img alt="" align="right" src="https://flat.badgen.net/gitlab/issues/bw3u/dotfiles"/>

<a href="https://i.imgur.com/SVPji8D.jpg">
  <img src="https://i.imgur.com/SVPji8D.jpg" alt="minimal" align="right" width="400px"/>
</a>

I casually distro hopping and I need a quick solution so..

- If your system is **Debian** or **Arch** based you can directly run [`setupEnvironment.sh`](setupEnvironment.sh) from your terminal, it will guide you through and automatically install apps & load dotfiles with your choices.

- If it's not unfortunately you have to install these applications by hand and manually copy the files to your home directory.

#
### [`setupEnvironment.sh`](setupEnvironment.sh) is capable of: ✨

- [x] Automatically detect your package manager and your OS.
- [x] Install dependencies.
- [x] Install **Window Manager** after your choice (will prompt you a dialog).
- [x] Install **Terminal Emulator** after your choice (will prompt you a dialog).
- [ ] Install **Text Editor** after your choice. <kbd>not yet</kbd>
- [ ] Install and setup **zsh** & **oh-my-zsh**. <kbd>not yet</kbd>
- [x] Copy dotfiles to your home directory.

If you have something in your mind and don't know shell scripting. Open an issue i'll take a look.

#
### License <img alt="" align="right" src="https://flat.badgen.net/badge/license/MIT/blue"/>

- The files and scripts in this repository are licensed under the [MIT](LICENSE.md) License.