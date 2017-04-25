# vim:set foldmethod=marker foldmarker={{{,}}} foldtext=foldtext() :

# Abbreviations in the form of variables {{{
export d=~/Dropbox
export n=~/Dropbox/Notas

#}}}
# Simple aliases {{{

alias g='git'
alias n='v ~/Dropbox/Notas/'
alias rm='trash-put'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias ea='ls -a'
alias e='ls'
alias el='ls -l'
alias ela='ls -la'
alias eal='ls -la'
alias gvimdiff='gvimdiff -f'
alias info='info --vi-keys'
alias transcriber='padsp transcriber'
alias rmtex='trash *.{aux,bbl,blg,dvi,log,gz,xml,out,bcf,fls,ist,lzo,lzs,glg,nav,snm} *{-blx.bib,fdb_latexmk,-tags.tex}'
alias df='df -h'
alias rpi_ip="arp -a | grep b8:27:eb | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'"
alias n7_ip="arp -a | grep d8:50:e6 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'"
alias me_ip="arp -a | grep a6:24:39 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'"
alias pdfgrep='pdfgrep --page-number'
alias d1='DISPLAY=:1'
alias sdcv='sdcv --color'
alias pandoc='pandoc --latex-engine=xelatex -V geometry:margin=1in'
alias rate="upower -d | grep energy-rate"
alias dc="rlwrap dc"
alias cr="clear"
alias pwdy='tmux set-buffer "$( pwd | perl -pe chomp )"'
alias vivim='vim -u NORC --cmd "set rtp=/"'
alias novim='nvim -u NONE'
alias youtube-dl='youtube-dl --prefer-ffmpeg'
alias sc='sc-im'
alias nboff='newsbeuter -C ~/.newsbeuter/config.offline -u ~/.newsbeuter/urls.offline'
alias nbtol='newsbeuter -C ~/.newsbeuter/config.oldreader -u ~/.newsbeuter/urls.oldreader'
# alias p='mpv --no-video'
alias p='nvlc'
alias vlc='nvlc'
alias l='v ~/Dropbox/linguistica/references/lingbib.bib'
alias f='fzf-tmux'
alias pv='youtube-dl -o - $(xsel) | mpv -'
alias sunmoon='gcal -c -Hno --moonimage-line=21'
alias ptop='sudo powertop'
alias umutt='mutt -F ~/.muttrc-umail'

# }}}
# Functions {{{

# Simple functions {{{

o()    { [[ $# -eq 1 ]] && xdg-open "$1" & }
fic()  { ls -1 "$1" | wc -l ; }
# pdfx() { gtk-launch PDF-Viewer.desktop "$1" &> /dev/null ; }
# I will prefer to use a script in ~/bin in order to be able to use it with ranger
u2w()  { echo $1 | sed -e "s|~|$HOME|" -e 's|/|\\|g' ; }
ctdw() { sleep $1m ; avplay ./share/sounds/ubuntu/stereo/desktop-login.ogg ; }
lfz()  { locate $@ | fzf-tmux ; }
a()    { audacious "$@" & }

#}}}
# vim-related {{{

neovim_start_server() {
  for i in '' {1..10}; do
    if [[ ! -e /tmp/nvimsocket$i ]]; then
      NVIM_LISTEN_ADDRESS=/tmp/nvimsocket$i nvim "$@"
      break
    fi
  done
}
neovim_nvr() {
  # I'm redirecting ERR to /DEV/NULL because I was getting an
  # annoying and insignificant error otherwise
  if [[ $1 =~ ^[0-9]$ ]]; then
    nvr --servername /tmp/nvimsocket${1} --remote-tab "$2" 2>/dev/null
  else
    nvr --servername /tmp/nvimsocket --remote-tab "$1" 2>/dev/null
  fi 
}
svim() {
  if [[ $1 =~ ^[0-9]$ ]]; then
    vim --servername vim${1} --remote-tab "$2"
  else
    vim --servername vim --remote-tab "$1"
  fi 
}
neovim_server_python() {
	python3 <<- EOF
		from neovim import attach
		from glob import glob
		
		sockets = glob('/tmp/nvim*/0')
		if sockets:
		  if '$#' == '2':
		    index = int('$1')
		    file = '$2'
		  elif '$#' == '1':
		    index = 0 
		    file = '$1'
		  elif '$#' == '0':
		    print(sockets)
		    quit()
		  else: quit()
		else: quit()
		
		filepath = '$PWD/' + file
		socket = sockets[index]
		nvim = attach('socket', path=socket)
		nvim.command(":tabe " + filepath.replace(' ','\ '))
	EOF
}

# alias vim='vim --servername vim'
alias vim='neovim_start_server'
alias v='neovim_start_server'
alias s='neovim_nvr'
alias sv='svim'
alias gv='gvim'

#}}}
# ps-related {{{

pstop() { kill -STOP $( ps aux | perl -lane ' /'$1'/ and !/perl/ and print @F[1] and exit' ) ; }
pcont() { kill -CONT $( ps aux | perl -lane ' /'$1'/ and !/perl/ and print @F[1] and exit' ) ; }
alias kstop='killall -STOP'
alias kcont='killall -CONT'

paug() {
  abre_inv='\x1b[7m'
  fecha_inv='\x1b[0m'
  ps aux | \
  sed -nr -e '
    1p;                                          # cabeçalho
    /sed -nr -e/d;                               # não imprime cabeçalho
    s/'$1'/'$abre_inv'&'$fecha_inv'/p            # inverte resultado '    
}

#}}}
# Search with google {{{
gsearch() {
  # initializes empty query variable
  query=''
  # concatenates words into query
  for term in $@; do
    query=$query'+'$term
  done
  # proceeds to search
  w3m 'http://www.google.com.br/search?ie=ISO-8859-1&hl=en-BR&source=hp&q='"$query"'&btnG=Google+Search&gbv=1'
} 

#}}}
# Search with google scholar {{{
gscholar() {
  # initializes empty query variable
  query=''
  # concatenates words into query
  for term in $@; do
    query=$query'+'$term
  done
  # proceeds to search
  w3m 'https://scholar.google.com/scholar?q='"$query"
} 

#}}}
# DIRSTACK-related {{{

pushd() {
  if [ $# -eq 0 ]; then
    DIR="${HOME}"
  else
    DIR="$1"
  fi

  builtin pushd "${DIR}" > /dev/null
  # echo -n "DIRSTACK: "
  # dirs
}
pushd_builtin() {
  builtin pushd > /dev/null
  # echo -n "DIRSTACK: "
  # dirs
}
popd() {
  builtin popd > /dev/null
  # echo -n "DIRSTACK: "
  # dirs
}
alias cd='pushd'
alias bk='popd'
alias fp='pushd_builtin'
alias cd-='cd -'

#}}}
# Automatically change the directory in bash after closing ranger {{{
# Compatible with ranger 1.4.2 through 1.7.*
#
# This is a bash function for .bashrc to automatically change the directory to
# the last visited one after ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.

function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        command cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

alias ranger=ranger-cd
# This binds Ctrl-O to ranger-cd:
bind '"\C-o":"ranger-cd\C-m"'
#}}}
#}}}
