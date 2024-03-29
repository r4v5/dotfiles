
# zshell configurations
autoload colors zsh/terminfo
colors
setopt promptsubst
fpath+=/usr/local/share/zsh-completions
fpath+=/opt/homebrew/share/zsh/site-functions
fpath+=~/.zfunc
typeset -U path

[ -z "$HOSTNAME" ] && HOSTNAME=$(hostname -s)

# Set history options
HISTFILE=~/.zsh_history
HISTSIZE=1000000000
SAVEHIST=1000000000
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY_TIME
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY


alias mv='nocorrect mv -i'      # no spelling correction on mv
alias mkdir='nocorrect mkdir'	# no spelling correction on mkdir
[[ -f $(which vim) ]] && alias vi='vim'
[[ -f $(which mvim 2>/dev/null) ]] && alias vim='mvim -v'
alias pks='source ~/.zshrc'     # make .zshrc into function instantly
alias sl=ls

# AUTOMATIC ls on chpwd *if* directory isn't too big.
function chpwd {
  integer ls_lines="$(ls -C | wc -l)"
  if [[ $ls_lines -eq 0 ]]; then
    true
  elif [[ $ls_lines -le 18 ]]; then
    ls
    echo "$fg[green] --[ Items: `ls | wc -l` ] --$reset_color"
  fi
}

bindkey -e
bindkey "^[[3~" delete-char
setopt nonomatch
setopt nohup

# set window titles
function precmd () {
  print -Pn "\033]0;%n@%m: %~\007"
}

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

# Add ~/bin for local packages
[[ -d "$HOME/bin" ]] && path=($HOME/bin "$path[@]")

# Ruby
# [[ -d "$HOME/.rbenv/bin" ]] && path=($HOME/.rbenv/bin "$path[@]")
[[ -f  $(which rbenv 2>/dev/null) ]] && eval "$(rbenv init -)"
[[ -f "$HOME/.rake_completion.zsh" ]] && source $HOME/.rake_completion.zsh

# Pyenv stuffs
[[ -e $(which pyenv 2> /dev/null) ]] && eval "$(pyenv init -)"

# golang
[ -d /usr/local/opt/go/libexec/bin ] && path+=/usr/local/opt/go/libexec/bin

# Allow editing the current command line in vim
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line


# Command line volume control
case `uname` in
  "Darwin")
    alias mute="osascript -e 'set volume output muted true'"
    ;;
  "Linux")
    [[ -f $(which pactl 2>/dev/null) ]] && alias mute="pactl set-sink-mute $(pactl info | grep "Default Sink" | cut -d " " -f3) toggle"
    ;;
esac

# GNURadio/PyBOMBS initiation
[[ -f "$HOME/code/target/setup_env.sh" ]] && source "$HOME/code/target/setup_env.sh"

# Rust if you got rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# starship
[[ -f "$(which starship)" ]] && eval "$(starship init zsh)"

[[ -e "${HOME}/.iterm2_shell_integration.zsh" ]] && source "${HOME}/.iterm2_shell_integration.zsh"

[ -s "${HOME}/.local_vars" ] && . "${HOME}/.local_vars"  # This loads machine-specific local vars outside of version control

export EDITOR=vim
