#!/bin/sh

########################################################
#            Docker Alias
########################################################

alias dc='docker ps'
alias dcommit='docker commit'
alias dcopy='docker cp'
alias dcs='docker ps -as'
alias di='docker images'
alias dinfo='docker info'
alias dlog='docker logs --follow'
alias dlogt='docker logs --tail 100'
alias dp='docker system prune'
alias drmac='docker rm `docker ps -a -q`'
alias drmcc='docker rm $(docker ps -qa --no-trunc --filter "status=created")'
alias drmdc='docker rm $(docker ps -qa --no-trunc --filter "status=exited")'
alias drmdi='docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
alias drmdn='docker network rm'
alias drmdv='docker volume rm $(docker volume ls -qf dangling=true)'
alias drmv='docker rm volume'
alias dstats='docker stats'
alias dvol='docker volume ls'
alias dvoli='docker volume inspect'
alias dclean=' \
  docker ps --no-trunc -aqf "status=exited" | xargs docker rm ; \
  docker images --no-trunc -aqf "dangling=true" | xargs docker rmi ; \
  docker volume ls -qf "dangling=true" | xargs docker volume rm'

dclean() {
  docker ps --no-trunc -aqf "status=exited" | xargs docker rm
  docker images --no-trunc -aqf "dangling=true" | xargs docker rmi
  docker volume ls -qf "dangling=true" | xargs docker volume rm
}

dhist() {
  docker history "$1" --format "{{.ID}}: {{.CreatedBy}}" --no-trunc
}

dlogin() {
  docker exec -it "$1" /bin/sh
}

dloginu() {
  docker exec -it -u "$1" "$2" /bin/sh
}

dlogn() {
  docker logs -f "$(docker ps | grep "$1" | awk "{print $1}")"
}

dpush() {
  docker push "$1"
}

drmc() {
  docker rm "$@"
}

drmi() {
  docker rmi "$@"
}

drun() {
  docker run -d --name "$1" -it --detach "$1" /bin/sh
}

dstop() {
  docker stop "$@"
}

dtag() {
  docker tag "$1" "$2"
}
#################################
