#!/bin/sh

if [ "$log_enable" = true ]; then
  log_enable=true
else
  log_enable=false
fi

cur_path="$(cd "$(dirname "$0")" && pwd)"
echo "Loading Aliases from : $cur_path"
echo "Log Enabled: $log_enable"

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

log() {
  if $log_enable; then
    printf "\n%s" "$*"
  fi
}

# Docker
if command_exists docker; then
  log "Sourcing docker aliases"
  [ -f "$cur_path"/aliases/docker.sh ] && . "$cur_path"/aliases/docker.sh && log " - done"
fi

# K8s
if command_exists kubectl; then
  log "Sourcing k8s aliases"
  [ -f "$cur_path"/aliases/k8s.sh ] && . "$cur_path"/aliases/k8s.sh && log " - done"
fi

# K3d
if command_exists k3d; then
  log "Sourcing k3d aliases"
  [ -f "$cur_path"/aliases/k3d.sh ] && . "$cur_path"/aliases/k3d.sh && log " - done"
fi

# git
if command_exists git; then
  log "Sourcing git aliases"
  [ -f "$cur_path"/aliases/git.sh ] && . "$cur_path"/aliases/git.sh && log " - done"

  # Enabling Git Ignore
  if [ -f "$cur_path"/aliases/private_gitignore_global ]; then
    cat "$cur_path"/aliases/gitignore_global "$cur_path"/aliases/private_gitignore_global >"${HOME}"/gitignore_global
    git config --global core.excludesfile "${HOME}"/gitignore_global
  else
    git config --global core.excludesfile "$cur_path"/aliases/gitignore_global
  fi
fi

# terraform
if command_exists terraform; then
  log "Sourcing terraform aliases"
  [ -f "$cur_path"/aliases/tform.sh ] && . "$cur_path"/aliases/tform.sh && log " - done"
fi

# aws
if command_exists aws; then
  log "Sourcing aws aliases"
  [ -f "$cur_path"/aliases/aws.sh ] && . "$cur_path"/aliases/aws.sh && log " - done"
fi

# openshift
if command_exists oc; then
  log "Sourcing ocp aliases"
  [ -f "$cur_path"/aliases/openshift.sh ] && . "$cur_path"/aliases/openshift.sh && log " - done"
fi

# podman
if command_exists podman; then
  log "Sourcing podman aliases"
  [ -f "$cur_path"/aliases/podman.sh ] && . "$cur_path"/aliases/podman.sh && log " - done"
fi

# GCP
if cmd_loc="$(type "gcloud")" || [ -z "${cmd_loc}" ]; then
  log "Sourcing gcloud aliases"
  [ -f "$cur_path"/aliases/gcp.sh ] && . "$cur_path"/aliases/gcp.sh && log " - done"
fi

# ansible
if command_exists ansible; then
  log "Sourcing ansible aliases"
  [ -f "$cur_path"/aliases/ansible.sh ] && . "$cur_path"/aliases/ansible.sh && log " - done"
fi

# vagrant
if command_exists vagrant; then
  log "Sourcing vagrant aliases"
  [ -f "$cur_path"/aliases/vagrant.sh ] && . "$cur_path"/aliases/vagrant.sh && log " - done"
fi

########################################################
########################################################
# General
. "$cur_path"/aliases/general.sh

# private aliases
find "$cur_path"/aliases -maxdepth 1 -type f -name "private*.sh" 2>/dev/null | while read -r file; do
  log "Sourcing $(basename "${file}") aliases"
  # shellcheck source=/dev/null
  . "${file}" && log " - done "
done

########################################################
########################################################

# Update the aliases
#. "$cur_path"/check-for-update.sh

# Unsetting
unset log_enable
