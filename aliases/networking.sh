#!/usr/bin/env sh

alias pubip="curl -s ipinfo.io"
# alias pubip='dig ANY +short @resolver2.opendns.com myip.opendns.com'
# alias pubip2="curl ifconfig.me"
alias pubipv4="curl -s https://api.ipify.org"
alias pubipv6="curl -s https://api6.ipify.org"
#alias pubipv4='curl https://ipv4.icanhazip.com/'
#alias pubip='dig ANY +short @resolver2.opendns.com myip.opendns.com'
alias pubip2="curl ifconfig.me"

list_open_sockets() {
  find / -type s
}

# Port
# Open Port
alias open_ports='lsof -nP -iTCP -sTCP:LISTEN'
alias list_all_ports='lsof -i -P -n'

get_port() {
  [ -z "$1" ] && echo "Usage: get_port <PORT>" && return
  out=$(lsof -i :"$1" -sTCP:LISTEN)
  [ -z "$out" ] && return
  echo "$out"
  ps -ef | grep "$(awk ' NR > 1 {print $2}' <<< "$out" | sort -u)"
}

kill_port() {
  if [[ ${#1} -eq 0 ]]; then
    echo "Provide a port number whose PID you'd like to kill"
    echo "kill_port <PORT>"
    return 64
  fi

  get_port "$1" | awk 'NR > 1 {print $2}' | sort -u | xargs kill -15
}
