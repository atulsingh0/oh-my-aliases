#!/bin/sh


alias pubip='dig ANY +short @resolver2.opendns.com myip.opendns.com'
alias pubip2="curl ifconfig.me"

list_open_sockets() {
  find / -type s
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
