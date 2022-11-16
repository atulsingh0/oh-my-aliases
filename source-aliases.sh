cur_path="$(cd "$(dirname "$0")" && pwd)"
echo "Loading Aliases from : $cur_path"

function command_exists() {
  command -v "$@" >/dev/null 2>&1
}

# General
source $cur_path/aliases/general.sh

# Docker
if command_exists docker; then
    [ -f  $cur_path/aliases/docker.sh ] && source $cur_path/aliases/docker.sh
fi

# K8s
if command_exists kubectl; then
    [ -f $cur_path/aliases/k8s.sh ] && source $cur_path/aliases/k8s.sh
fi

# K3d
if command_exists k3d; then
    [ -f $cur_path/aliases/k3d.sh ] && source $cur_path/aliases/k3d.sh
fi

# git
if command_exists git; then
    [ -f $cur_path/aliases/git.sh ] && source $cur_path/aliases/git.sh
fi

# terraform
if command_exists terraform; then
    [ -f $cur_path/aliases/tform.sh ] && source $cur_path/aliases/tform.sh
fi

# openshift
if command_exists oc; then
    [ -f $cur_path/aliases/openshift.sh ] && source $cur_path/aliases/openshift.sh
fi

# aws
if command_exists aws; then
    [ -f $cur_path/aliases/aws.sh ] && source $cur_path/aliases/aws.sh
fi

# podman
if command_exists podman; then
    [ -f $cur_path/aliases/podman.sh ] && source $cur_path/aliases/podman.sh
fi

# GCP
if cmd_loc="$(type -p "gcloud")" || [[ -z ${cmd_loc} ]]; then
    [ -f $cur_path/aliases/gcp.sh ] && source $cur_path/aliases/gcp.sh
fi
