#!/bin/sh

cur_path="$(cd "$(dirname "$0")" && pwd)"

if enable_plugin batcat; then
  alias bat=batcat
fi

if enable_plugin nvim; then
  alias vi=nvim
fi

if enable_plugin rsync; then
  alias cp=rsync
fi

alias python=python3
# if command -v most >/dev/null 2>&1; then
#   export PAGER=most
# fi
alias c='clear'
alias help='man'
alias cgpg='gpg-connect-agent reloadagent /bye'
alias ls='ls -GFh --color=auto'
alias ll='ls -GFhlrt --color=auto'
alias lla='ls -GFhlrta --color=auto'
#alias cp='cp -R'
alias scp='scp -r'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='egrep --color=auto'
alias grepc='egrep --color=always'
alias less='less -R'
alias fs='echo FY$(date -v+11m +%Y) q$((($(date +%m|sed s/^0//)+10)%12/3+1))'
alias pubip='dig ANY +short @resolver2.opendns.com myip.opendns.com'
alias randstr="cat /dev/urandom | env LC_ALL=C tr -dc 'A-Za-z0-9' | head -c"
alias diff='diff --color'
alias mkdir='mkdir -p'
alias df='df -kTh'
alias tarxz='tar -xzf'
alias tarx='tar -xf'
alias tarcz='tar -cvzf'
alias tarc='tar -cvf'
alias dateu='date -u'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias pserver='python3 -m http.server'
alias cdtmp="cd \$(mktemp -d)"
alias epoch='date +%s'
alias plz='sudo'

# Conversion
alias urldecode='python3 -c "import sys, urllib as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib as ul; print(ul.quote_plus(sys.argv[1]))"'
alias json2yml='python3 -c "import sys, yml, json; print(yaml.safe_dump(json.loads(sys.stdin.read())))"'
alias yml2json='python3 -c "import sys, yml, json; print(json.safe_dump(yaml.loads(sys.stdin.read())))"'

# Crypto
alias sshkey='ssh-keygen -b 4096 -t ed25519'
alias readcert='openssl x509 -noout -text -in'
alias readcertdata='openssl x509 -noout -text'
selfcert() {
  openssl req -newkey rsa:4096 -x509 -sha256 -nodes -keyout "$1".key.pem -days 365 -out "$1".pem
}

# ping
alias ping='ping -c 5'

# systemd
alias sctl='systemctl'
alias jctl='journalctl'

# ça pipe
alias -g G='| grep'
alias -g L='| less'
alias -g M='| most'
alias -g NE='2> /dev/null'
alias -g NUL='> /dev/null 2>&1'
alias -g S='| sort'
alias -g T='tail -f'
alias -g W='| wc -l'

# take 
take() {
  mkdir -p "$1" && cd "$1" || return
}

# Port
# Open Port
alias open_ports='lsof -nP -iTCP -sTCP:LISTEN'
alias list_all_ports='lsof -i -P -n'

list_port() {
  [ -z "$1" ] && echo "Usage: list_port <PORT>" && exit
  lsof -i :$1 -sTCP:LISTEN
}

kill_port() {
	if [[ ${#1} -eq 0 ]]; then
		echo "Provide a port number whose PID you'd like to kill"
    echo "kill_port <PORT>"
		return 64
	fi

  list_port $1 | awk 'NR > 1 {print $2}' | xargs kill -15
}

# List font
fonts() {
  fc-list | awk '{$1=""}1' | cut -d: -f1 | sort | uniq
}

mask() {
    local n=5                        # number of chars to leave
    local a="${1:0:${#1}-n}"         # take all but the last n chars
    local b="${1:${#1}-n}"           # take the final n chars
    printf "%s%s\n" "${a//?/*}" "$b" # substitute a with asterisks
}

htpass(){
  out=$(mktemp)
  htpasswd -b -c "${out}" "$1" "$2" && cat "${out}"
}



# Reload Aliases
reload() {
  case $(basename $SHELL) in
  zsh) [ -f "${HOME}/.zshrc" ] && source ${HOME}/.zshrc ;; #&& source ${cur_path}/../source-aliases.sh;;
  bash) [ -f "${HOME}/.bashrc" ] && source ${HOME}/.bashrc ;;
  *) echo "Unrecognized shell $SHELL" ;;
  esac
}

list_open_sockets() {
  find / -type s
}

# use as - sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# alias rm_old="rm"

# rm() {
#   printf "You are going to delete \033[31m $* \033[0m from \033[31m %s \033[0m\n" 
#   printf >&2 '%s ' 'Continue  ? (y/n)'
#   read -r ans
#   case $ans in
#   [yY])
#     rm_old $*
#     ;;
#   [nN])
#     echo "Do nothing and Exiting"
#     ;;
#   *) printf " \033[31m %s \n\033[0m" "invalid input" ;;
#   esac
# }

# repeat() {
#   local n=$1
#   local command=$2

#   for ((i=1; i<=n; i++)); do
#     eval $command &
#   done
#   wait
# }

# Reload go program
# go_kill_and_rerun() {
#   fswatch -o "$PWD/$2" | xargs -n1 -I{} kill "$1" && go run "$PWD/$2"
# }

# go_reload() {
#   while true; do
#     go run "$PWD/$1" &
#     PID=$!
#     fswatch -o "$PWD"
#     kill -15 $PID echo "Killed process - $PID"
#   done
# }
