#!/usr/bin/env sh

#################################
#        SSL/TLS/Cryptography
#################################

alias sshkey='ssh-keygen -b 4096 -t ed25519'
alias readssh='ssh-keygen -l -f'

hash keychain && isKeychain=true || isKeychain=false

sshadd() {
  eval $(keychain --eval $*)
}

sshkill() {
  keychain -k all
}

sshclear() {
  keychain --clear
}

sshlist() {
  keychain --list
}

genpubssh() {
  # generate public key from private key
  ssh-keygen -f "$1" -N "" -y >"$1".pub
}

genhtpass() {
  # generate htpassword
  openssl passwd $1
}

alias readcert='openssl x509 -noout -text -in'
alias readcertdata='openssl x509 -noout -text'

selfcert() {
  # generate self-signed certificate
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
