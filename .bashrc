cur_path="$(cd "$(dirname "$0")" && pwd)"

# Docker
source $cur_path/aliases/docker.sh

# K8s
source $cur_path/aliases/k8s.sh

# General
source $cur_path/aliases/general.sh

# git
source $cur_path/aliases/git.sh

# terraform
source $cur_path/aliases/tform.sh

# openshift
source $cur_path/aliases/openshift.sh