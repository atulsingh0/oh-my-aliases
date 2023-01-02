#!/bin/sh

log_enable=false

cur_path="$(cd "$(dirname "$0")" && pwd)"
echo "Loading Aliases from : $cur_path"

function command_exists() {
  command -v "$@" >/dev/null 2>&1
}

function log() {
  if $log_enable; then
    echo $*
  fi
}

# General
source $cur_path/aliases/general.sh

# Personal
find $cur_path/aliases -maxdepth 1 -type f -name "personal*.sh" 2>/dev/null | while read -r file; do
  log -ne "Sourcing $(basename $file) aliases"
  source $file && log " - done "
done

# Docker
if command_exists docker; then
  log -ne "Sourcing docker aliases"
  [ -f $cur_path/aliases/docker.sh ] && source $cur_path/aliases/docker.sh && log " - done "
fi

# K8s
if command_exists kubectl; then
  log -ne "Sourcing k8s aliases"
  [ -f $cur_path/aliases/k8s.sh ] && source $cur_path/aliases/k8s.sh && log " - done"
fi

# K3d
if command_exists k3d; then
  log -ne "Sourcing k3d aliases"
  [ -f $cur_path/aliases/k3d.sh ] && source $cur_path/aliases/k3d.sh && log " - done"
fi

# git
if command_exists git; then
  log -ne "Sourcing git aliases"
  [ -f $cur_path/aliases/git.sh ] && source $cur_path/aliases/git.sh && log " - done"

  # Enabling Git Ignore
  if [[ -f ${cur_path}/aliases/personal_gitignore_global ]]; then
    cat ${cur_path}/aliases/gitignore_global ${cur_path}/aliases/personal_gitignore_global >${HOME}/gitignore_global
    git config --global core.excludesfile ${HOME}/gitignore_global
  else
    git config --global core.excludesfile ${cur_path}/aliases/gitignore_global
  fi
fi

# terraform
if command_exists terraform; then
  log -ne "Sourcing terraform aliases"
  [ -f $cur_path/aliases/tform.sh ] && source $cur_path/aliases/tform.sh && log " - done"
fi

# aws
if command_exists aws; then
  log -ne "Sourcing aws aliases"
  [ -f $cur_path/aliases/aws.sh ] && source $cur_path/aliases/aws.sh && log " - done"
fi

# openshift
if command_exists oc; then
  log -ne "Sourcing ocp aliases"
  [ -f $cur_path/aliases/openshift.sh ] && source $cur_path/aliases/openshift.sh && log " - done"
fi

# podman
if command_exists podman; then
  log -ne "Sourcing podman aliases"
  [ -f $cur_path/aliases/podman.sh ] && source $cur_path/aliases/podman.sh && log " - done"
fi

# GCP
if cmd_loc="$(type -p "gcloud")" || [[ -z ${cmd_loc} ]]; then
  log -ne "Sourcing gcloud aliases"
  [ -f $cur_path/aliases/gcp.sh ] && source $cur_path/aliases/gcp.sh && log " - done"
fi

# ansible
if command_exists ansible; then
  log -ne "Sourcing ansible aliases"
  [ -f $cur_path/aliases/ansible.sh ] && source $cur_path/aliases/ansible.sh && log " - done"
fi
