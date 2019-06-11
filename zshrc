#.zshrc, created by r4v5 having ripped off a significant chunk from blcknight,
# who took a significant chunk from someone else, and fucked with by compinstall.

# i like color
autoload colors zsh/terminfo
autoload -Uz vcs_info
colors
setopt promptsubst
[ -d /usr/local/share/zsh-completions ] && fpath=(/usr/local/share/zsh-completions $fpath)

typeset -U path

[ -z "$HOSTNAME" ] && HOSTNAME=$(hostname -s)
# prompt colors, whut!
case $HOSTNAME in
  Mason*)
    HOSTCOLOR=green
    ;;
  cubie*)
    HOSTCOLOR=grey
    ;;
  ganglia)
    HOSTCOLOR=white
    ;;
  hippocampus)
    HOSTCOLOR=cyan
    ;;
  do*)
    HOSTCOLOR=green
    ;;
  cortex*)
    HOSTCOLOR=magenta
    ;;
  *)
    HOSTCOLOR=yellow
    ;;
esac

[[ $LOGNAME == "root" ]] && HOSTCOLOR=red

zstyle ':vcs_info:*' formats '%F{5}[%F{2}%b%F{5}]%f'

vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}

PS1="%{$fg_bold[$HOSTCOLOR]%}%h%(?..(%?%)) %m %{$fg_bold[blue]%}%1d %#%b%o %{$terminfo[sgr0]%}"
RPS1=%B%(1j.%j|.)$'$(vcs_info_wrapper)'%t%b

# Keychain goodies
[ -f "$(which keychain 2>/dev/null)" ] && keychain -q $HOME/.ssh/*_[dr]sa
[ -f "${HOME}/.keychain/`hostname`-sh" ] && source $HOME/.keychain/`hostname`-sh

# if we've got lesspipe, it sure is nice to have
[[ -f lesspipe.sh ]] && export LESSOPEN="|lesspipe.sh %s"

alias -g L='|less'
alias -g G='|grep'
alias -g T='|tail'
alias -g H='|head'
alias -g N='&>/dev/null&'

[[ -f $(which screen 2>/dev/null) ]] && alias sc='screen -Ux'
[[ -f $(which tmux 2>/dev/null) ]] && alias sc='tmux attach'
alias psaux='ps -aux G'
alias cl='clear'
alias cls=cl
alias mv='nocorrect mv -i'      # no spelling correction on mv
[[ -f $(which rsync) ]] && alias cp='rsync --progress'
alias mkdir='nocorrect mkdir'	# no spelling correction on mkdir
[[ -f $(which vim) ]] && alias vi='vim'
[[ -f $(which mvim 2>/dev/null) ]] && alias vim='mvim -v'
alias pks='source ~/.zshrc'     # make .zshrc into function instantly
alias sl=ls

# LS Options.
alias ls="ls -F -b -h"

function ir { ps aux | grep $1 | grep -v grep }
function tz { tar -xzvf "$1" }
function bz { tar -xjvf $1 }

# AUTOMATIC ls on chpwd *if* directory isn't too big.
function chpwd {
  integer ls_lines="$(ls -C | wc -l)"
  if [ $ls_lines -eq 0 ]; then
  elif [ $ls_lines -le 18 ]; then
    ls
    echo "$fg[green] --[ Items: `ls | wc -l` ] --$reset_color"
  fi
}

bindkey -e
bindkey "^[[3~" delete-char
setopt nonomatch
setopt nohup

zstyle -e ':completion:*:ssh:*' hosts \
  'reply=($(sed -e "/^#/d" -e "s/ .*\$//" -e "s/,/ /g" \
  ~/.ssh/known_hosts 2>/dev/null))'
zstyle -e ':completion:*:scp:*' hosts \
  'reply=($(sed -e "/^#/d" -e "s/ .*\$//" -e "s/,/ /g" \
  ~/.ssh/known_hosts 2>/dev/null))'


# Functions for displaying good stuff in a terminal title
case $TERM in
  screen*|tmux*)
    precmd () {
      print -Pn "\033]0;%n@%m%#  %~ %l  %w :: %T\a"
      printf "\033kzsh\033\\"
    }
    preexec () {
      print -Pn "\033]0;%n@%m%#  <$1>  %~ %l  %w :: %T\a"
      printf "\033k$(echo "$1")\033\\"
    }
  ;;
  xterm*)
    precmd () {
      print -Pn "\033]0;%n@%m%#  %~ %l  %w :: %T\a"
    }
    preexec () {
      print -Pn "\033]0;%n@%m%#  <$1>  %~ %l  %w :: %T\a"
    }
  ;;
esac

# The following lines were added by compinstall

zstyle ':completion:*' completer _list _complete _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=** r:|=**'
zstyle ':completion:*' menu select=8
zstyle ':completion:*' original false
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/r4v5/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall
[[ -d "$HOME/bin" ]] && path=($HOME/bin "$path[@]")

[[ -d "$HOME/.rbenv/bin" ]] && path=($HOME/.rbenv/bin "$path[@]")
[[ -f  $(which rbenv 2>/dev/null) ]] && eval "$(rbenv init -)"

# Pyenv stuffs
[[ -e $(which pyenv 2> /dev/null) ]] && eval "$(pyenv init -)"

# golang
[ -d /usr/local/opt/go/libexec/bin ] && path+=/usr/local/opt/go/libexec/bin


[[ -f "$HOME/.rake_completion.zsh" ]] && source $HOME/.rake_completion.zsh

# Command line volume control
case `uname` in
  "Darwin")
    alias mute="osascript -e 'set volume output muted true'"
    ;;
  "Linux")
    alias mute="pactl set-sink-mute 0 toggle"
    # lol sound on linux
    ;;
esac

# GNURadio/PyBOMBS initiation
[[ -f "$HOME/code/target/setup_env.sh" ]] && source "$HOME/code/target/setup_env.sh"

# Rust if you got rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# powerline/zsh
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
[[ -f /usr/share/powerline/zsh/powerline.zsh ]] && . /usr/share/powerline/zsh/powerline.zsh
[[ -f /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]] && . /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh

[[ -e "${HOME}/.iterm2_shell_integration.zsh" ]] && source "${HOME}/.iterm2_shell_integration.zsh"
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
## Friggin' TRAMP
[ $TERM = "dumb" ] && unsetopt zle && PS1='$ '
TZ="US/Central"
export TZ

[ -s "${HOME}/.local_vars" ] && . "${HOME}/.local_vars"  # This loads machine-specific local vars outside of version control
alias aws='aws-mfa --log-level ERROR --duration 86400 && aws'
export EDITOR=vim
