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

echo "PLUGINS are: $PLUGINS"
enable_plugin() {
  grep -c "$1" <<< "${PLUGINS}" >/dev/null 2>&1
}

log() {
  if $DEBUG; then
    printf "\n%s" "$*"
  fi
}

########################################################
########################################################

## Setting UP Env Variable if any 
. "${cur_path}/env.sh"


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
if enable_plugin docker; then
  log "Sourcing docker aliases"
  . "${cur_path}"/aliases/docker.sh && log " - done"
fi

# K8s
if enable_plugin kubectl; then
  log "Sourcing k8s aliases"
  . "${cur_path}"/aliases/k8s.sh && log " - done"
  . "${cur_path}"/aliases/k8s-plugin.sh && log " - done"
fi

if enable_plugin helm; then
  log "Sourcing helm aliases"
  . "${cur_path}"/aliases/helm.sh && log " - done"
fi

# K3d
if enable_plugin k3d; then
  log "Sourcing k3d aliases"
  . "${cur_path}"/aliases/k3d.sh && log " - done"
fi

# git
if enable_plugin git; then
  log "Sourcing git aliases"
  . "${cur_path}"/aliases/git.sh && log " - done"

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
if enable_plugin gh; then
  if [ -n "$GITHUB_TOKEN" ] && [ -n "$GH_HOST" ]; then
    echo "GH_HOST is set: $GH_HOST"
    log "Sourcing gh (github) aliases"
    [ -f "${cur_path}"/aliases/gh.sh ] && . "${cur_path}"/aliases/gh.sh && log " - done"
  else
    echo "env variable GH_HOST or GITHUB_TOKEN is not set."
  fi
fi

# terraform
if enable_plugin terraform; then
  log "Sourcing terraform aliases"
  . "${cur_path}"/aliases/tform.sh && log " - done"
fi

# aws
if enable_plugin aws; then
  log "Sourcing aws aliases"
  . "${cur_path}/aliases/aws.sh" && log " - done"
fi

# openshift
if enable_plugin oc; then
  log "Sourcing ocp aliases"
  . "${cur_path}"/aliases/openshift.sh && log " - done"
fi

# podman
if enable_plugin podman; then
  log "Sourcing podman aliases"
  . "${cur_path}"/aliases/podman.sh && log " - done"
fi

# GCP
if cmd_loc="$(type "gcloud")" || [ -z "${cmd_loc}" ]; then
  log "Sourcing gcloud aliases"
  . "${cur_path}"/aliases/gcp.sh && log " - done"
fi

# ansible
if enable_plugin ansible; then
  log "Sourcing ansible aliases"
  . "${cur_path}"/aliases/ansible.sh && log " - done"
fi

# vagrant
if enable_plugin vagrant; then
  log "Sourcing vagrant aliases"
  . "${cur_path}"/aliases/vagrant.sh && log " - done"
fi

# delta
if enable_plugin delta; then
  log "Sourcing delta aliases"
  . "${cur_path}"/aliases/delta.sh && log " - done"
fi

# asciinema
if enable_plugin asciinema; then
  log "Sourcing asciinema aliases"
  . "${cur_path}"/aliases/asciinema.sh && log " - done"
fi

# Letsencrypt
log "Sourcing letsencrypt aliases"
[ -f "${cur_path}"/aliases/letsencrypt.sh ] && . "${cur_path}"/aliases/letsencrypt.sh && log " - done"

# GPG
log "Sourcing PGP (gnupg) aliases"
[ -f "${cur_path}"/aliases/pgp.sh ] && . "${cur_path}"/aliases/pgp.sh && log " - done"

# Pass - Password Store
log "Sourcing pass aliases"
[ -f "${cur_path}"/aliases/pass.sh ] && . "${cur_path}"/aliases/pass.sh && log " - done"

# Golang
log "Sourcing golang aliases"
[ -f "${cur_path}"/aliases/golang.sh ] && . "${cur_path}"/aliases/golang.sh && log " - done"

# General
log "Sourcing Networking aliases"
. "${cur_path}"/aliases/networking.sh
log "Sourcing SSL aliases"
. "${cur_path}"/aliases/ssl.sh


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
