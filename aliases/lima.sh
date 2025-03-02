#!/usr/bin/env sh

alias li='limactl'
alias listart='limactl start'
alias listop='limactl stop'
alias lishell='limactl shell'
alias lils='limactl list'

lirestart() {
    limactl stop $1 \
    && limactl start $1
}