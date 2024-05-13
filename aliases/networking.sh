#!/bin/sh


alias pubip='dig ANY +short @resolver2.opendns.com myip.opendns.com'

list_open_sockets() {
  find / -type s
}
