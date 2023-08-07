#!/bin/sh
if command -v batcat >/dev/null 2>&1; then
  alias bat=batcat
fi

if command -v nvim >/dev/null 2>&1; then
  alias vi=nvim
fi

if command -v python3 >/dev/null 2>&1; then
  alias python=python3
fi

# if command -v most >/dev/null 2>&1; then
#   export PAGER=most
# fi
alias c='clear'
alias ls='ls -GFh --color'
alias ll='ls -GFhlrt --color'
alias la='ls -GFhlrta --color'
alias egrep='egrep --color=always'
alias fgrep='fgrep --color=always'
alias grep='egrep --color=always'
alias less='less -R'
alias fs='echo FY$(date -v+11m +%Y) q$((($(date +%m|sed s/^0//)+10)%12/3+1))'
alias pubip='dig ANY +short @resolver2.opendns.com myip.opendns.com'
alias urldecode='python3 -c "import sys, urllib as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib as ul; print(ul.quote_plus(sys.argv[1]))"'
alias json2yml='python3 -c "import sys, yml, json; print(yaml.safe_dump(json.loads(sys.stdin.read())))"'
alias yml2json='python3 -c "import sys, yml, json; print(json.safe_dump(yaml.loads(sys.stdin.read())))"'
alias randstr="cat /dev/urandom | env LC_ALL=C tr -dc 'A-Za-z0-9' | head -c"
alias sshkey='ssh-keygen -b 4096 -t ed25519'

selfcert() {
  openssl req -newkey rsa:4096 -x509 -sha256 -nodes -keyout "$1".key.pem -days 365 -out "$1".pem
}

reload() {
case $(basename $SHELL) in
    zsh)  source ~/.zshrc ;;
    bash) source ~/.bashrc ;;
    *)    echo "Unrecognized shell $SHELL" ;;
esac 
}
