#!/usr/bin/env sh

##############################
# GCP Command aliases
##############################

alias gc='gcloud'
alias gcprj='gcloud projects list'
alias gcrmprj='gcloud projects delete'
alias gcaddprj='gcloud projects create'
alias gcdesprj='gcloud projects describe'
alias gcsetprj='gcloud config set project'


gcp_get_roles() {
  [ $# -lt 3 ] && echo "Usage: gcp_get_roles <PROJECT_ID> [sa|user] <ID_EMAIL>" && return 

  PROJECT_ID="$1"
  EMAIL="$3"
  if [[ "$2" == "user" ]]; then
    TYPE="user"
  else
    TYPE="serviceAccount"
  fi

#  echo "$PROJECT_ID $TYPE $EMAIL"

  gcloud projects get-iam-policy $PROJECT_ID \
  --flatten="bindings[].members" \
  --format="table(bindings.role)" \
  --filter="bindings.members:$TYPE:$EMAIL"
}
