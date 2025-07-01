#!/usr/bin/env sh

alias lc='limactl'
alias lcstart='limactl start'
alias lcstop='limactl stop'
alias lcshell='limactl shell'
alias lcls='limactl list'
alias lcssh=lcshell 
alias lcshow='limactl show-ssh'

lcrestart() {
    limactl stop $1 \
    && limactl start $1
}
