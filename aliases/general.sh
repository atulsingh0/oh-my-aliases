#!/bin/sh

cur_path="$(cd "$(dirname "$0")" && pwd)"

if command_exists batcat; then
  alias ccat=batcat
fi

if command_exists bat; then
  alias ccat=bat
fi

if command_exists nvim; then
  alias vi=nvim
fi

if command_exists python3; then
  alias python=python3
fi

if command_exists rsync; then
  alias cp=rsync
fi

# if command -v most >/dev/null 2>&1; then
#   export PAGER=most
# fi
alias c='clear'
alias ls='ls -GFh --color'
alias ll='ls -GFhlrt --color'
alias lla='ls -GFhlrta --color'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='egrep --color=auto'
alias less='less -R'
alias fs='echo FY$(date -v+11m +%Y) q$((($(date +%m|sed s/^0//)+10)%12/3+1))'
alias pubip='dig ANY +short @resolver2.opendns.com myip.opendns.com'
alias urldecode='python3 -c "import sys, urllib as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib as ul; print(ul.quote_plus(sys.argv[1]))"'
alias json2yml='python3 -c "import sys, yml, json; print(yaml.safe_dump(json.loads(sys.stdin.read())))"'
alias yml2json='python3 -c "import sys, yml, json; print(json.safe_dump(yaml.loads(sys.stdin.read())))"'
alias randstr="cat /dev/urandom | env LC_ALL=C tr -dc 'A-Za-z0-9' | head -c"
alias sshkey='ssh-keygen -b 4096 -t ed25519'
alias diff='diff --color'
alias readcert='openssl x509 -noout -text -in'

fonts() {
  fc-list | awk '{$1=""}1' | cut -d: -f1 | sort | uniq
}

selfcert() {
  openssl req -newkey rsa:4096 -x509 -sha256 -nodes -keyout "$1".key.pem -days 365 -out "$1".pem
}

reload() {
  case $(basename $SHELL) in
  zsh) [ -f "${HOME}/.zshrc" ] && source ${HOME}/.zshrc ;; #&& source ${cur_path}/../source-aliases.sh;;
  bash) [ -f "${HOME}/.bashrc" ] && source ${HOME}/.bashrc ;;
  *) echo "Unrecognized shell $SHELL" ;;
  esac
}

kill_port() {
  lsof -i :$1 -sTCP:LISTEN | awk 'NR > 1 {print $2}' | xargs kill -15
}

# Reload go program
go_kill_and_rerun() {
  fswatch -o "$PWD/$2" | xargs -n1 -I{} kill "$1" && go run "$PWD/$2"
}

go_reload() {
  while true; do
    go run "$PWD/$1" &
    PID=$!
    fswatch -o "$PWD"
    kill -15 $PID echo "Killed process - $PID"
  done
}
