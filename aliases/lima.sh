#!/usr/bin/env sh

alias lc='limactl'
alias lcstart='limactl start'
alias lcstop='limactl stop'
alias lcshell='limactl shell'
alias lcls='limactl list'
alias lcssh=lcshell 
alias lcshow='limactl show-ssh'
alias lcedit='limactl edit'

lcreboot() {
    [ -z $1 ] && echo "Usage: lcreboot <lima_vm_name>" && return;
    limactl stop $1 \
    && limactl start $1
}

lcip() {
  [ -z $1 ] && echo "Usage: lcip <lima_vm_name>" && return;
  limactl shell $1 ip addr show
}


