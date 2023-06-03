#!/bin/sh

arec() {
  asciinema rec $1
}

aup() {
  asciinema auth &&
    asciinema upload $*
}

aplay() {
  asciinema play $*
}
