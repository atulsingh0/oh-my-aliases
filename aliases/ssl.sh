#!/bin/sh
#################################
#        SSL/TLS
#################################

chk_tls() {
  nmap --script ssl-enum-ciphers -p 443 "$1"
}
