#!/bin/sh

cur_path="$(cd "$(dirname "$0")" && pwd)"
echo "Loading Aliases from : $cur_path"

function command_exists() {
  command -v "$@" >/dev/null 2>&1
}

# General
source $cur_path/aliases/general.sh

# Personal
find $cur_path/aliases -maxdepth 1 -type f -name "personal*.sh" 2>/dev/null | while read -r file; do
  echo -ne "Sourcing $(basename $file) aliases"
  source $file && echo " - done"
done

# Docker
if command_exists docker; then
  echo -ne "Sourcing docker aliases"
  [ -f $cur_path/aliases/docker.sh ] && source $cur_path/aliases/docker.sh && echo " - done"
fi

# K8s
if command_exists kubectl; then
  echo -ne "Sourcing k8s aliases"
  [ -f $cur_path/aliases/k8s.sh ] && source $cur_path/aliases/k8s.sh && echo " - done"
fi

# K3d
if command_exists k3d; then
  echo -ne "Sourcing k3d aliases"
  [ -f $cur_path/aliases/k3d.sh ] && source $cur_path/aliases/k3d.sh && echo " - done"
fi

# git
if command_exists git; then
  echo -ne "Sourcing git aliases"
  [ -f $cur_path/aliases/git.sh ] && source $cur_path/aliases/git.sh && echo " - done"
fi

# terraform
if command_exists terraform; then
  echo -ne "Sourcing terraform aliases"
  [ -f $cur_path/aliases/tform.sh ] && source $cur_path/aliases/tform.sh && echo " - done"
fi

# aws
if command_exists aws; then
  echo -ne "Sourcing aws aliases"
  [ -f $cur_path/aliases/aws.sh ] && source $cur_path/aliases/aws.sh && echo " - done"
fi

# openshift
if command_exists oc; then
  echo -ne "Sourcing ocp aliases"
  [ -f $cur_path/aliases/openshift.sh ] && source $cur_path/aliases/openshift.sh && echo " - done"
fi

# podman
if command_exists podman; then
  echo -ne "Sourcing podman aliases"
  [ -f $cur_path/aliases/podman.sh ] && source $cur_path/aliases/podman.sh && echo " - done"
fi

# GCP
if cmd_loc="$(type -p "gcloud")" || [[ -z ${cmd_loc} ]]; then
  echo -ne "Sourcing gcloud aliases"
  [ -f $cur_path/aliases/gcp.sh ] && source $cur_path/aliases/gcp.sh && echo " - done"
fi
