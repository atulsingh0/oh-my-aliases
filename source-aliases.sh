#!/bin/sh

if [ "$DEBUG" = true ]; then
  DEBUG=true
  set -x
else
  DEBUG=false
fi

cur_path="$(cd "$(dirname "$0")" && pwd)"
echo "Loading Aliases from : ${cur_path}"
echo "Debug: $DEBUG"

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

log() {
  if $DEBUG; then
    printf "\n%s" "$*"
  fi
}

# Sourcing Environment Variable

# shellcheck disable=SC1019
[ -f "${cur_path}"/env.sh ] && . "${cur_path}"/env.sh && log "Sourced environment variables"

# shellcheck disable=SC1019
[ -f "${cur_path}"/private_env.sh ] && . "${cur_path}"/private_env.sh && log "Sourced private environment variables"

########################################################
########################################################
## Loading aliases from a folder
if [ -n "${CUSTOM_ALIAS_FOLDER}" ]; then
  echo "CUSTOM_ALIAS_FOLDER is set: $CUSTOM_ALIAS_FOLDER"
  find "${CUSTOM_ALIAS_FOLDER}" -maxdepth 1 -type f -name "*.sh" 2>/dev/null | while read -r file; do
    log "Sourcing $(basename "${file}") aliases"
    # shellcheck source=/dev/null
    . "${file}" && log " - done "
  done
else
  echo "env variable CUSTOM_ALIAS_FOLDER is not set."
fi
########################################################
########################################################

# Docker
if command_exists docker; then
  log "Sourcing docker aliases"
  [ -f "${cur_path}"/aliases/docker.sh ] && . "${cur_path}"/aliases/docker.sh && log " - done"
fi

# K8s
if command_exists kubectl; then
  log "Sourcing k8s aliases"
  [ -f "${cur_path}"/aliases/k8s.sh ] && . "${cur_path}"/aliases/k8s.sh && log " - done"
  [ -f "${cur_path}"/aliases/k8s-plugin.sh ] && . "${cur_path}"/aliases/k8s-plugin.sh && log " - done"
fi

if command_exists helm; then
  log "Sourcing helm aliases"
  [ -f "${cur_path}"/aliases/helm.sh ] && . "${cur_path}"/aliases/helm.sh && log " - done"
fi

# K3d
if command_exists k3d; then
  log "Sourcing k3d aliases"
  [ -f "${cur_path}"/aliases/k3d.sh ] && . "${cur_path}"/aliases/k3d.sh && log " - done"
fi

# git
if command_exists git; then
  log "Sourcing git aliases"
  [ -f "${cur_path}"/aliases/git.sh ] && . "${cur_path}"/aliases/git.sh && log " - done"

  # Enabling Git Ignore
  cat "${cur_path}"/aliases/gitignore_global >"${HOME}"/.oma_gitignore_global
  if [ -f "${cur_path}"/aliases/private_gitignore_global ]; then
    cat "${cur_path}"/aliases/private_gitignore_global >>"${HOME}"/.oma_gitignore_global
  fi

  if [ -f "${CUSTOM_ALIAS_FOLDER}/gitignore" ]; then
    cat "${CUSTOM_ALIAS_FOLDER}/gitignore" >>"${HOME}"/.oma_gitignore_global
  fi

  git config --global core.excludesfile "${HOME}"/.oma_gitignore_global
fi

# gh github cli
if command_exists gh; then
  if [ -n "$GITHUB_TOKEN" ] && [ -n "$GH_HOST" ]; then
    echo "GH_HOST is set: $GH_HOST"
    log "Sourcing gh (github) aliases"
    [ -f "${cur_path}"/aliases/gh.sh ] && . "${cur_path}"/aliases/gh.sh && log " - done"
  else
    echo "env variable GH_HOST or GITHUB_TOKEN is not set."
  fi
fi

# terraform
if command_exists terraform; then
  log "Sourcing terraform aliases"
  [ -f "${cur_path}"/aliases/tform.sh ] && . "${cur_path}"/aliases/tform.sh && log " - done"
fi

# aws
if command_exists aws; then
  log "Sourcing aws aliases"
  [ -f "${cur_path}"/aliases/aws.sh ] && . "${cur_path}/aliases/aws.sh" && log " - done"
fi

# openshift
if command_exists oc; then
  log "Sourcing ocp aliases"
  [ -f "${cur_path}"/aliases/openshift.sh ] && . "${cur_path}"/aliases/openshift.sh && log " - done"
fi

# podman
if command_exists podman; then
  log "Sourcing podman aliases"
  [ -f "${cur_path}"/aliases/podman.sh ] && . "${cur_path}"/aliases/podman.sh && log " - done"
fi

# GCP
if cmd_loc="$(type "gcloud")" || [ -z "${cmd_loc}" ]; then
  log "Sourcing gcloud aliases"
  [ -f "${cur_path}"/aliases/gcp.sh ] && . "${cur_path}"/aliases/gcp.sh && log " - done"
fi

# ansible
if command_exists ansible; then
  log "Sourcing ansible aliases"
  [ -f "${cur_path}"/aliases/ansible.sh ] && . "${cur_path}"/aliases/ansible.sh && log " - done"
fi

# vagrant
if command_exists vagrant; then
  log "Sourcing vagrant aliases"
  [ -f "${cur_path}"/aliases/vagrant.sh ] && . "${cur_path}"/aliases/vagrant.sh && log " - done"
fi

# delta
if command_exists delta; then
  log "Sourcing delta aliases"
  [ -f "${cur_path}"/aliases/delta.sh ] && . "${cur_path}"/aliases/delta.sh && log " - done"
fi

# asciinema
if command_exists asciinema; then
  log "Sourcing asciinema aliases"
  [ -f "${cur_path}"/aliases/asciinema.sh ] && . "${cur_path}"/aliases/asciinema.sh && log " - done"
fi

# Letsencrypt
log "Sourcing letsencrypt aliases"
[ -f "${cur_path}"/aliases/letsencrypt.sh ] && . "${cur_path}"/aliases/letsencrypt.sh && log " - done"

# GPG
log "Sourcing GPG aliases"
[ -f "${cur_path}"/aliases/gpg.sh ] && . "${cur_path}"/aliases/gpg.sh && log " - done"

########################################################
########################################################
# General
. "${cur_path}"/aliases/general.sh

# private aliases
find "${cur_path}"/aliases -maxdepth 1 -type f -name "private*.sh" 2>/dev/null | while read -r file; do
  log "Sourcing $(basename "${file}") aliases"
  # shellcheck source=/dev/null
  . "${file}" && log " - done "
done

########################################################
########################################################
# Update the aliases
#. "${cur_path}"/check-for-update.sh

# Unsetting
set +x
unset DEBUG
