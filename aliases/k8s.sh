#!/usr/bin/env sh

##############################
# K8s Command aliases
##############################

alias k='kubectl'
alias ksys='kubectl --namespace=kube-system'
alias kg='kubectl get'
alias kno='kubectl get nodes'
alias kns='kubectl get namespaces'
alias kc='kubectl config'
alias knsc="kubectl config view --minify --output 'jsonpath={..namespace}'"
alias kcw='kubectl config view'
alias kcc='kubectl config get-contexts'
#alias kdebugpod='kubectl run z-test-pod --image=radial/busyboxplus:curl -i --tty'
alias kdebugpod="kubectl run z-test-pod -it --image=atulsingh0/busuboxplus:kubectl"
alias kdebugdns='kubectl run tmp-shell --rm -i --tty --image nicolaka/netshoot'
alias ksetctxc='kubectl config set-context --current --namespace' # Or use kubectx binary
#alias kaddctx='_(){ kubectl config set-context "$1" --namespace="$2" && kubectl config use-context "$1" }; _'
alias krmctx='kubectl config unset'
alias kpod='kubectl get pods'
alias kpodi="kubectl get pods| egrep -v 'Completed' | grep '0/'"
alias kpodiw="watch -n 2 'kubectl get pods| egrep -v Completed | grep \'0/\''"
alias kpodl='kubectl get pods --show-labels'
alias kjob='kubectl get jobs'
alias kpexec='kubectl get pods -l layer=execution'
alias kpapp='kubectl get pods -l layer=application'
alias kpdata='kubectl get pods -l layer=data'
alias kpl='kubectl get pods -l'
#alias kpodn='kubectl get pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName'
alias kdep='kubectl get deployments'
alias ksvc='kubectl get services'
alias kingress='kubectl get ingress'
alias ksecrets='kubectl get secrets'
alias kcm='kubectl get cm'
alias kds='kubectl get ds'
alias ksvcl='kubectl get services | grep "Load"'
alias kedit='kubectl edit'
alias klogs='kubectl logs -f'
alias klog='kubectl logs --tail=50 -f'
alias kdes='kubectl describe'
alias kdesp='kubectl describe pod'
alias kdesd='kubectl describe deployment'
alias kdess='kubectl describe service'
alias kdesi='kubectl describe ingress'
alias kdesj='kubectl describe job'
alias kdesc='kubectl describe cm'
#alias kdel='kubectl delete'
alias kexp='kubectl get -o yaml'
alias kpog='kubectl get pods | egrep '
alias krs='kubectl get po -o custom-columns="Name:metadata.name,CPU-limit:spec.containers[*].resources.limits.cpu, CPU-request:spec.containers[*].resources.requests.cpu, memory-limits:spec.containers[*].resources.limits.memory, memory-request:spec.containers[*].resources.requests.memory"'
alias kcpu='kubectl get po -o custom-columns="Name:metadata.name,CPU-limit:spec.containers[*].resources.limits.cpu, CPU-Request:spec.containers[*].resources.requests.cpu"'
alias kmem='kubectl get po -o custom-columns="Name:metadata.name,Memory-limit:spec.containers[*].resources.limits.memory, Memory-Request:spec.containers[*].resources.requests.memory"'


alias kscale='kubectl scale --replicas='

kscaleup() {
  kubectl scale --replicas=1 "$@"
}

kscaledown() {
  kubectl scale --replicas=0 "$@"
}

kdebugshell() {
 kubectl debug "$1" -it --image=nicolaka/netshoot
}

 kdel() {
  printf "You are going to delete \033[31m $1 \033[0m from \033[31m %s \033[0m\n" "$(kubectx -c)/$(kubens -c)"
  printf >&2 '%s ' 'Continue  ? (y/n)'
  read -r ans
  case $ans in
  [yY])
    kubectl delete $*
    ;;
  [nN])
    echo "Do nothing and Exiting"
    ;;
  *) printf " \033[31m %s \n\033[0m" "invalid input" ;;
  esac
}

 kevents() {
  res=""
  for res in "${@:1}"; do
    echo "Events from $1 $res:"
    kubectl describe "$1" "$res" | sed -n '/Events:/, $p'
    echo ""
  done
}

 knpod() {
  echo
  for res in "${@}"; do
    echo "Events from Node: ${res}"
    kubectl describe node "${res}" | sed -n '/Namespace/,/Events:/p'
    echo ""
  done
}

 ksetctx() {
  echo "Setting Namespce $2 in context $1"
  kubectl config set-context "$1" --namespace="$2"
  echo "Using Context $1"
  kubectl config use-context "$1"
}

 kenv() {
  #kubectl get pod/$1 -o json | jq '.spec.containers[].name + " " + .spec.containers[].env[].name' | column -t
  [ -z $1 ] && echo "Provide the Pod Name" && return
  kubectl describe pod/"$1" | sed -n '/Environment:/,/Mounts:/p' | sed "s/Mounts:/------------------------------------------/"
}

 kenva() {
  kubectl get pods -o json | jq '.items[].metadata.name + " " + .items[].spec.containers[].name + " " + .items[].spec.containers[].env[].name + " " + .items[].spec.containers[].env[].value' | column -t
}

 kdelp() {
  for name in "$@"; do
    kubectl delete pod "${name}"
  done
}

alias kdelpi="kubectl get pods | egrep -v 'Running|Completed|Pending' |grep -v NAME| cut -d' ' -f1 | xargs kubectl delete pod"

kdelps() {
  kubectl get pods | grep "$1" | grep -v NAME| cut -d' ' -f1 | xargs kubectl delete pod
}

#  kdelpi(){
#     for name in $(kubectl get pods | egrep -v 'Running|Completed|Pending' |grep -v NAME| cut -d' ' -f1 | tr "\n" " ");do
#       kubectl delete pod $name
#     done
# }

 kbackup() {
  K8S_NS=$(helm list -o yaml | yq '.[].namespace')
  CHART=$(helm list -o yaml | yq '.[].chart')
  VER=$(helm list -o yaml | yq '.[].revision')
  RANDOM_STR=$(env LC_ALL=C tr -dc 'a-z0-9' /dev/urandom | head -c 8)
  velero backup create "${K8S_NS}-${RANDOM_STR}" --include-namespaces "${K8S_NS}" -n velero -l "${CHART}--${VER}"
}

 krestore() {
  BACKUP="$1"
  if [ -z "$2" ]; then
    K8S_NS=$(helm list -o yaml | yq '.[].namespace')
  else
    K8S_NS=$2
  fi
  velero restore create --include-namespaces "${K8S_NS}" --from-backup "${BACKUP}"
}

 kgsecret() {
   [ -z $2 ] && echo "Provide Secret Key" && return
   kubectl get secret "$1" -o "jsonpath={.data['${2/./\\.}']}" | base64 -d
}

 kexec() {
  kubectl exec "$1" -- "${@:2}"
}

 kbash() {
  kubectl exec -it "$1" -- sh
}


aws_kaddctx() {
  name="$1"
  if [ -z "$2" ]; then
    aws eks update-kubeconfig --name "$name" --region "$(aws configure get region)"
  else
    aws eks update-kubeconfig --name "$name" --region "$2"
  fi
}

gcp_kaddctx() {
  name="$1"
  if [ "#$" == 1 ]; then 
    gcloud container clusters get-credentials "$name" --region "$(gcloud config get compute/region)" --project "$(gcloud config get project)"
  elif [ "#$" == 2 ]; then
      gcloud container clusters get-credentials "$name" --region "$2" --project "$(gcloud config get project)"
  else 
      gcloud container clusters get-credentials "$name" --region "$2" --project "$3"
  fi
}
