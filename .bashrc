# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-*color|screen-*color|rxvt-*color|tmux-*color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases (but only if the terminal isn't "dumb" (gvim's terminal)
if [ $TERM != "dumb" ]; then 
  if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
  fi
fi

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# path
# export PATH=$HOME/bin:$PATH:

export CDPATH=.:$HOME:$HOME/Dropbox:$HOME/Dropbox/linguistica/mit/yearless:$HOME/Dropbox/linguistica/pos-doc:$HOME/Dropbox/linguistica/:$HOME/Dropbox/linguistica/kisedje/

# to prevent ctrl-s from activating xoff (which would need ctrl-q to revive the terminal)
stty ixany
stty ixoff -ixon

# to inactivate native C-w deletion up to the next space, leaving deletion for readline,
# which is set (by .inputrc) to delet up to the preceding backslash.
stty werase undef

# So ranger only loads local settings
RANGER_LOAD_DEFAULT_RC=FALSE

# sets title of terminal window (tmux already does it from the title of its windows)
if [[ $TERM == @(xterm*|screen-256color|rxvt*) ]]
then
  set_title_of_terminal_window() {
    local HPWD="$PWD"
    case $HPWD in
      $HOME) HPWD="~" ;;
      *) HPWD=`basename "$HPWD"` ;;
    esac
    echo -ne "\033]0;$HPWD\007" 
  }
  PROMPT_COMMAND="set_title_of_terminal_window; $PROMPT_COMMAND"
fi

# # set titles of multiplexer's windows 
# if [[ $TERM == @(screen*|tmux*) ]]
# then
#   set_title_of_multiplexers_window() {
#     local HPWD="$PWD"
#     case $HPWD in
#       $HOME) HPWD="~";;
#       *) HPWD=`basename "$HPWD"`;;
#     esac
#     printf '\ek%s\e\\' "$HPWD" 
#   }
#   PROMPT_COMMAND="set_title_of_multiplexers_window; $PROMPT_COMMAND"
# fi

[ "$HOSTNAME" != "Z835" ] &&
  EDITOR=nvim &&
  _Z_CMD=c &&
  . ~/bin/z/z.sh

set -o vi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# activates pandoc's bash completion
[ "$HOSTNAME" != "Z835" ] &&
  eval "$(pandoc --bash-completion)"

# activates tmux's bash completion
. /usr/share/doc/tmux/examples/bash_completion_tmux.sh

# makes PS1 shorter by showing only the last directory
# (`pwd` is your friend)
PS1="$(echo $PS1|sed 's/\\w/\\W/g') "

# use nvim as default man pager
[ "$HOSTNAME" != "Z835" ] &&
  export MANPAGER="/bin/sh -c \" col -b | nvim -c 'set ft=man ts=8 nomod nolist nonu noma' - ; echo \""

BASE16_SHELL=$HOME/.config/base16-shell/                                                            
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

PATH=$PATH:/opt/freerdp-nightly/bin/
