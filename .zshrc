export ZSH="/home/bw3u/.oh-my-zsh"
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export EDITOR="nvim"
export VISUAL="nvim"
export JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto"
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
export DEBFULLNAME="Berkcan Ucan"
export DEBEMAIL="berkcan@vivaldi.net"
export NVM_SYMLINK_CURRENT=true

ZSH_THEME="bw3u"
plugins=(git
				history
				command-not-found
				zsh-nvm
				emacs
				#zsh-interactive-cd
				zsh-autosuggestions
				#helpers
				#colors
				#pr-node
				)

source $ZSH/oh-my-zsh.sh

### ARCHIVE EXTRACTION
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;      
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

### PATH ###
export PATH="$PATH":"$HOME/.local/bin"
export PATH="$PATH":"$HOME/.emacs.d/bin"
export PATH="$PATH":"$HOME/.android/sdk/platform-tools"
export PATH="$PATH":"$HOME/.android/sdk/tools"
export PATH="$PATH":"$HOME/.android/sdk"
export ANDROID_SDK_ROOT=$HOME/.android/sdk
export PATH=$PATH:/usr/local/go/bin

### MY ALIASES ###
alias vim="nvim"
alias startemacs="/usr/bin/emacs --daemon"
alias install="sudo pacman -S"
alias update="sudo pacman -Syyu"
alias updateaur="paru -Sua"
alias paru='paru --skipreview'
alias mirror="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"
alias ll='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ls='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias jctl="journalctl -p 3 -xb"
alias df='df -h'
alias free='free -m'
alias buildpkg="debuild -us -uc -i -k'DDCE2848B6CEEE0B' -S"
alias signpkg="debsign -k'AB7F BC1E DB97 9025 26A8  C2EA DDCE 2848 B6CE EE0B'"
alias chpkg="sudo chown -R bw3u:bw3u"
alias uploadpkg="dput ppa:bw3u/focal"
alias kubectl='microk8s kubectl'

# Git
alias gaa="git add ."
alias gcm="git commit -m"
alias gca="git commit --amend --no-edit"
alias gst="git status"
alias gps="git push -u origin main"

colorscript --random

[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# It's pretty neat but slows down zsh. https://starship.rs
# eval "$(starship init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/bw3u/.local/lib/google-cloud-sdk/path.zsh.inc' ]; then . '/home/bw3u/.local/lib/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/bw3u/.local/lib/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/bw3u/.local/lib/google-cloud-sdk/completion.zsh.inc'; fi
