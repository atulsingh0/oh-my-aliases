#!/usr/bin/env sh

#################################
#        SSL/TLS/Cryptography
#################################

alias gensshkey='ssh-keygen -b 4096 -t ed25519'
alias readssh='ssh-keygen -l -f'
alias ssh-fingerprint=readssh

hash keychain && isKeychain=true || isKeychain=false

sshadd() {
  [ -f "$HOME/.ssh/$1" ] && ssh-add "$HOME/.ssh/$1" || ssh-add "$1"
}

sshdel() {
  [ -f "$HOME/.ssh/$1" ] && ssh-add -d "$HOME/.ssh/$1" || ssh-add -d "$1"
}

sshkill() {
  keychain -k all
}

sshclear() {
  ssh-add -D
}

sshlist() {
  ssh-add -l
}

genpubssh() {
  # generate public key from private key
  [ -z "$1" ] && echo "Uage: genpubssh <PRIVATE_KEY>" && return
  ssh-keygen -f "$1" -N "" -y >"$1".pub
}

genhtpass() {
  # generate htpassword
  [ -z "$1" ] && echo "Usage: genhtpass <PASSWORD>" && return
  openssl passwd "$1"
}

alias readcert='openssl x509 -noout -text -in'
alias readcertdata='openssl x509 -noout -text'

selfcert() {
  # generate self-signed certificate
  [ -z "$1" ] && echo "Usage: selfcert <CERT_NAME>" && return
  openssl req -newkey rsa:4096 -x509 -sha256 -nodes -keyout "$1".key.pem -days 365 -out "$1".pem
}


chk_tls() {
  if [[ $2 -le 0 ]]; then
    echo "using port 443"
    port=443
  else
    port=$2
  fi
  nmap --script ssl-enum-ciphers -p $port "$1"
}

get_tls() {
  if [[ $2 -le 0 ]]; then
    echo "using port 443"
    port=443
  else
    port=$2
  fi
  openssl s_client -servername "$1" -connect "$1:$port"
}
