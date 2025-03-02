#!/usr/bin/env sh

##############################
# Podman Command aliases
##############################

alias pi='podman images'
alias pc='podman ps'
alias pca='podman ps -a'
alias pinspect='podman inspect'
alias pstart='_(){ podman run --rm -it -d "$1" "${@:2}" ;};_'
alias prun='_(){ podman run --rm -t "$1" "${@:2}" ;};_'
alias plogin='_(){ podman exec -it "$1"  /bin/bash  ;};_'
alias prmdc='podman rm $(podman ps -qa --no-trunc --filter "status=exited")'
alias prmcc='podman rm $(podman ps -qa --no-trunc --filter "status=created")'
alias prmdi='podman rmi $(podman images --filter "dangling=true" -q --no-trunc)'
alias prmdv='podman volume rm $(podman volume ls -qf dangling=true)'
#alias prmdn="podman network rm $(podman network ls | grep bridge | awk '/ / { print $1 }')"
alias prmac='podman rm $(podman ps -a -q)'
alias prmi='_(){ podman rmi "$@" ;};_'
alias prmc='_(){ podman rm "$@" ;};_'
alias pstop='_(){ podman stop "$@" ;};_'
alias ptag='_(){ podman tag "$1" "$2";};_'
alias ppush='_(){ podman push "$1" ;};_'
alias plog='podman logs --follow'
alias psha="podman inspect --format='{{index .RepoDigests 0}}'"
alias pbuild='podman build -t $1 $2'
