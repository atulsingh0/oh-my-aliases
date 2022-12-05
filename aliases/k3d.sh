##############################
# K3d Command aliases
##############################

function k3dc() {
  k3d cluster create $1 --api-port 6550 --servers 1 --agents 3 --port 8080:80@loadbalancer --wait
}

alias k3dd="k3d cluster delete"
alias k3dstop="k3d cluster stop"
alias k3dstart="k3d clusrer start"
