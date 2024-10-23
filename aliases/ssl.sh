#!/bin/sh
#################################
#        SSL/TLS/Cryptography
#################################

alias sshkey='ssh-keygen -b 4096 -t ed25519'
alias readsshkey='ssh-keygen -l -f'

alias sshadd='keychain --agents ssh --eval'

genpubssh() {
  # generate public key from private key
  ssh-keygen -f "$1" -N "" -y > "$1".pub
}

alias readcert='openssl x509 -noout -text -in'
alias readcertdata='openssl x509 -noout -text'

selfcert() {
  # generate self-signed certificate 
  openssl req -newkey rsa:4096 -x509 -sha256 -nodes -keyout "$1".key.pem -days 365 -out "$1".pem
}

chk_tls() {
  nmap --script ssl-enum-ciphers -p 443 "$1"
}
