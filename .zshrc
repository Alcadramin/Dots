export ZSH="/home/bw3u/.oh-my-zsh"
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="most"
export JAVA_HOME="/usr/lib/jvm/default/bin/"
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
export NVM_SYMLINK_CURRENT=true
export CHROME_EXECUTABLE="/usr/bin/chromium"

ZSH_THEME="bw3u"
plugins=(
    git 
    history
    command-not-found
    zsh-nvm
	emacs
	zsh-autosuggestions
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
export SPICETIFY_INSTALL="$HOME/spicetify-cli"
export PATH="$PATH":"$HOME/.local/bin"
export PATH="$PATH":"$HOME/.emacs.d/bin"
export PATH="$PATH":"$HOME/.android/sdk/platform-tools"
export PATH="$PATH":"$HOME/.android/sdk/tools"
export PATH="$PATH":"$HOME/.android/sdk"
export PATH="$SPICETIFY_INSTALL:$PATH"
export ANDROID_SDK_ROOT=$HOME/.android/sdk
export GOROOT=/usr/lib/go
export GOPATH=$HOME/dev/go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

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
alias composer="php7 /usr/bin/composer" # To run composer with php74
alias php="php7"
alias ssh="kitty +kitten ssh"

# Git
alias gaa="git add ."
alias gcm="git commit -m"
alias gca="git commit --amend --no-edit"
alias gst="git status"
alias gps="git push -u origin main"
alias gtc="git rev-list --all --count"

colorscript --random

#[ -f $HOME/.miniconda3/etc/profile.d/conda.sh ] && source $HOME/.miniconda3/etc/profile.d/conda.sh
[ -f /opt/conda/etc/profile.d/conda.sh ] && source /opt/conda/etc/profile.d/conda.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/bw3u/.local/lib/google-cloud-sdk/path.zsh.inc' ]; then . '/home/bw3u/.local/lib/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/bw3u/.local/lib/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/bw3u/.local/lib/google-cloud-sdk/completion.zsh.inc'; fi

export CUDA_HOME=/usr/local/cuda
