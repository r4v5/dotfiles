#.zshrc, created by r4v5 having ripped off a significant chunk from blcknight,
# who took a significant chunk from someone else, and fucked with by compinstall.

# i like color
autoload colors zsh/terminfo
colors

# get a basic idea for options for files and shit
case `uname` in 
	[Ll]inux)
		THISUNAME=linux
		;;
	[Cc][Yy][Gg][Ww][Ii][Nn]*)
		THISUNAME=cygwin
		;;
	*[Bb][Ss][Dd])
		THISUNAME=bsd
		;;
esac

# prompt colors, whut!
case $HOSTNAME in
    lenin)
	HOSTCOLOR=green
	;;
    cubieboard)
	HOSTCOLOR=magenta
	;;
    udoo)
	HOSTCOLOR=white
	;;
    hippocampus)
	HOSTCOLOR=blue
	;;
    linuxvm*)
	HOSTCOLOR=yellow
	;;
esac

[[ $LOGNAME == "root" ]] && HOSTCOLOR=red

PS1="%{$fg_bold[$HOSTCOLOR]%}%h%(?..(%?%)) %m %{$fg_bold[blue]%}%1d %#%b%o %{$terminfo[sgr0]%}"
RPS1=%B%(1j.%j|.)%t%b
precmd () {
case $TERM in
	screen*|xterm*|rxvt*)
		print -Pn "]0;%n@%m:%~ "
	;;
	*)
	;;
esac
}

# Keychain goodies
[ -f $(which keychain) ] && [ -f $HOME/.ssh/id_dsa ] && keychain -q $HOME/.ssh/id_dsa
[ -f ${HOME}/.keychain/${HOSTNAME}-sh ] && source $HOME/.keychain/${HOSTNAME}-sh

# if we've got lesspipe, it sure is nice to have
[[ -f lesspipe.sh ]] && export LESSOPEN="|lesspipe.sh %s"

alias -g '...'='../..'
alias -g '....'='../../..'
alias -g '.....'='../../../..'
alias -g '......'='../../../../..'
alias -g '.......'='../../../../../..'

alias -g L='|less'
alias -g G='|grep'
alias -g T='|tail'
alias -g H='|head'
alias -g N='&>/dev/null&'

[[ -f $(which screen) ]] && alias sc='screen -Ux'
[[ -f $(which tmux) ]] && alias sc='tmux -CC attach'
alias psaux='ps -aux G'
alias cl='clear'
alias cls=cl
alias mv='nocorrect mv -i'      # no spelling correction on mv
[[ -f $(which rsync) ]] && alias cp='rsync --progress'
alias mkdir='nocorrect mkdir'	# no spelling correction on mkdir
[[ -f $(which vim) ]] && alias vi='vim'

alias pks='source ~/.zshrc'     # make .zshrc into function instantly
alias xmm='xmodmap ~/.Xmodmap'
alias sl=ls

# LS Options.
[[ $THISUNAME == "linux" ]] || [[ $THISUNAME == "cygwin" ]] && alias ls="ls --color -F -b -h"
[[ $THISUNAME == "bsd" ]] && alias ls="ls -F"

function ir { ps aux | grep $1 | grep -v grep }
function killit { killall -9 $1 }
function tz { tar -xzvf "$1" }
function bz { tar -xjvf $1 }

# Usage: pskill <application/program name>
pskill()
{ 
	kill -9 $(ps aux | grep $1 | grep -v grep | awk '{ print $1 }')
		echo -n "Killed $1 process..."
		}

# AUTOMATIC ls on chpwd *if* directly isn't too big.
function chpwd {
	integer ls_lines="$(ls -C | wc -l)"
	if [ $ls_lines -eq 0 ]; then
	elif [ $ls_lines -le 18 ]; then
		ls
		echo "\e[1;32m --[ Items: `ls | wc -l` \e[1;32m]--"
	fi
	}

bindkey -e

# I really need to set up paths in here somehow in a hostname-dependent way. Oh well.
# also what doesn't a Sun have?
PATH=/bin:/usr/local/bin::/usr/bin::/sbin:/usr/sbin:/usr/local/sbin
case $HOSTNAME in
	catenoid)
		PATH=$PATH:/home/r4v5/bin
		;;
	McChoxy)
		PATH=$PATH:/home/r4v5/bin
		*)
		;;
esac

# binds for ctrl- and ctrl-alt-arrows
case $TERM in
	xterm*|rxvt*|mlterm|aterm|screen)
		bindkey 'Od' backward-word
		bindkey '^[Oc' forward-word
	;;
	*)
	;;
esac


# set up the control sextet
bindkey '[3~' delete-char
bindkey '[7~' beginning-of-line
bindkey '[8~' end-of-line
bindkey '[5~' beginning-of-buffer-or-history
bindkey '[6~' end-of-buffer-or-history

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
	xterm*|screen*|rxvt|(K|a)term)
	precmd () {
		print -Pn "\033]0;%n@%m%#  %~ %l  %w :: %T\a" 
	}
	preexec () {
		print -Pn "\033]0;%n@%m%#  <$1>  %~ %l  %w :: %T\a" 
	}
	;;
esac

# The following lines were added by compinstall

# This is a lot of disk usage and time when you spawn a term in order to
# tab-complete man pages. Whether this is worthwhile is up to you.
[[ $HOSTNAME == "helicoid" ]] || [[ $HOSTNAME == "[st]u[nx]*" ]] && {

compctl -f -x 'S[1][2][3][4][5][6][7][8][9]' -k '(1 2 3 4 5 6 7 8 9)' \
  - 'R[[1-9nlo]|[1-9](|[a-z]),^*]' -K 'match-man' \
  - 's[-M],c[-1,-M]' -g '*(-/)' \
  - 's[-P],c[-1,-P]' -c \
  - 's[-S],s[-1,-S]' -k '( )' \
  - 's[-]' -k '(a d f h k t M P)' \
  - 'p[1,-1]' -c + -K 'match-man' \
  -- man
}	      



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

TZ="/usr/share/zoneinfo/US/Central"
export TZ
## Friggin' TRAMP
[ $TERM = "dumb" ] && unsetopt zle && PS1='$ '
