cur_path="$(cd "$(dirname "$0")" && pwd)"
echo "Loading Aliases from : $cur_path"

# General
source $cur_path/aliases/general.sh

# Docker
if ! [[ -x $(docker --version 2> /dev/null) ]]; then
    [ -f  $cur_path/aliases/docker.sh ] && source $cur_path/aliases/docker.sh
fi

# K8s
if ! [[ -x $(kubectl version --short 2> /dev/null) ]]; then
    [ -f $cur_path/aliases/k8s.sh ] && source $cur_path/aliases/k8s.sh
fi

# K3d
if ! [[ -x $(k3d version 2> /dev/null) ]]; then
    [ -f $cur_path/aliases/k3d.sh ] && source $cur_path/aliases/k3d.sh
fi

# git
if ! [[ -x $(git --version) ]]; then
    [ -f $cur_path/aliases/git.sh ] && source $cur_path/aliases/git.sh
fi

# terraform
if ! [[ -x $(terraform --version 2> /dev/null ) ]]; then
    [ -f $cur_path/aliases/tform.sh ] && source $cur_path/aliases/tform.sh
fi

# openshift
if ! [[ -x $(oc --version 2> /dev/null) ]]; then
    [ -f $cur_path/aliases/openshift.sh ] && source $cur_path/aliases/openshift.sh
fi

# aws
if ! [[ -x $(aws --version 2> /dev/null) ]]; then
    [ -f $cur_path/aliases/aws.sh ] && source $cur_path/aliases/aws.sh
fi

# podman
if ! [[ -x $(podman --version 2> /dev/null) ]]; then
    [ -f $cur_path/aliases/podman.sh ] && source $cur_path/aliases/podman.sh
fi

# GCP
if cmd_loc="$(type -p "gcloud")" || [[ -z ${cmd_loc} ]]; then
    [ -f $cur_path/aliases/gcp.sh ] && source $cur_path/aliases/gcp.sh
fi
