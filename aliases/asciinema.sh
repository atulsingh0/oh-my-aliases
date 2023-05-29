#!/bin/sh

trec() {
  asciinema rec
}

tup() {
  asciinema auth &&
    asciinema $*
}
