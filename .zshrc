export ZSH="/home/bw3u/.oh-my-zsh"
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export EDITOR="kak"
export VISUAL="kak"
export JAVA_HOME=/usr/lib/jvm/default
#export NVM_LAZY_LOAD=true
#export NVM_COMPLETION=true

ZSH_THEME="bw3u"
plugins=(git
				history
				command-not-found
				#zsh-nvm
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
export PATH="$PATH":"$HOME/Android/Sdk/platform-tools"
export PATH="$PATH":"$HOME/Android/Sdk/tools"

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

colorscript --random

[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
#eval "$(starship init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/bw3u/.local/lib/google-cloud-sdk/path.zsh.inc' ]; then . '/home/bw3u/.local/lib/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/bw3u/.local/lib/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/bw3u/.local/lib/google-cloud-sdk/completion.zsh.inc'; fi
