#!/bin/sh

##############################
# K8s Plugin Command aliases
##############################

if command_exists kubecolor; then
  alias kg='kubecolor get'
  alias kno='kubecolor get nodes'
  alias kns='kubecolor get namespaces'
  alias kpod='kubecolor get pods'
  alias kpodi="kubecolor get pods| egrep -v 'Completed' | grep '0/'"
  alias kpodiw="watch -n 2 'kubecolor get pods| egrep -v Completed | grep \'0/\''"
  alias kpodl='kubecolor get pods --show-labels'
  alias kjob='kubecolor get jobs'
  alias kpexec='kubecolor get pods -l layer=execution'
  alias kpapp='kubecolor get pods -l layer=application'
  alias kpdata='kubecolor get pods -l layer=data'
  alias kpl='kubecolor get pods -l'
  alias kdep='kubecolor get deployments'
  alias ksvc='kubecolor get services'
  alias kingress='kubecolor get ingress'
  alias ksecrets='kubecolor get secrets'
  alias kcm='kubecolor get cm'
  alias kds='kubecolor get ds'
  alias ksvcl='kubecolor get services | { head -1 ; grep "Load" ; }'
  alias kexp='kubecolor get -o yaml'
  alias kpog='kubecolor get pods | egrep '

  alias kdes='kubecolor describe'
  alias kdesp='kubecolor describe pod'
  alias kdesd='kubecolor describe deployment'
  alias kdess='kubecolor describe service'
  alias kdesi='kubecolor describe ingress'
  alias kdesj='kubecolor describe job'
  alias kdesc='kubecolor describe cm'
fi
