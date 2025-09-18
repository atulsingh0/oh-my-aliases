#!/usr/bin/env sh

## To store your env variables
## Do not store any password/creds in this file
## to store those details, create a file "private_env.sh"

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
setopt HIST_IGNORE_SPACE

SEDOPTION="-i "
if [[ "$OSTYPE" == "darwin"* ]]; then
  SEDOPTION="-i ''"
fi

