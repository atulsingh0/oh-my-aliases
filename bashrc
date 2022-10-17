cur_path="$(cd "$(dirname "$0")" && pwd)"

# General
source $cur_path/aliases/general.sh

# Docker
if ! [[ -x $(docker --version) ]]; then
    source $cur_path/aliases/docker.sh
fi

# K8s
if ! [[ -x $(kubectl version) ]]; then
    source $cur_path/aliases/k8s.sh
fi

# K3d
if ! [[ -x $(k3d version) ]]; then
    source $cur_path/aliases/k3d.sh
fi

# git
if ! [[ -x $(git --version) ]]; then
    source $cur_path/aliases/git.sh
fi

# terraform
if ! [[ -x $(terraform --version) ]]; then
    source $cur_path/aliases/tform.sh
fi
# openshift
if ! [[ -x $(oc --version) ]]; then
    source $cur_path/aliases/openshift.sh
fi

# aws
if ! [[ -x $(aws --version) ]]; then
    source $cur_path/aliases/aws.sh
fi

# podman
if ! [[ -x $(podman --version) ]]; then
    source $cur_path/aliases/podman.sh
fi

# GCP
if cmd_loc="$(type -p "gcloud")" || [[ -z ${cmd_loc} ]]; then
    source $cur_path/aliases/gcp.sh
fi
