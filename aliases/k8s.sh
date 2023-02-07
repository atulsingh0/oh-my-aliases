##############################
# K8s Command aliases
##############################

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

alias k='kubectl'
alias ksys='kubectl --namespace=kube-system'
alias kno='kubectl get nodes'
alias kns='kubectl get namespaces'
alias kc='kubectl config'
alias knsc="kubectl config view --minify --output 'jsonpath={..namespace}'"
alias kcw='kubectl config view'
alias kcc='kubectl config get-contexts'
#alias kdebugpod='kubectl run z-test-pod --image=radial/busyboxplus:curl -i --tty'
alias kdebugpod="kubectl run z-test-pod -it --image=atulsingh0/busuboxplus:kubectl"

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
alias ksvcl='kubectl get services | { head -1 ; grep "Load" ; }'
alias kg='kubectl get'
alias kgp='_() { kubectl get pod/$1; }; _'
alias kgd='_() { kubectl get deploy/$1; }; _'
alias kgs='_() { kubectl get svc/$1; }; _'
alias kedit='kubectl edit'
alias keditp='_() { kubectl edit pod/$1; }; _'
alias keditd='_() { kubectl edit deploy/$1; }; _'
alias kedits='_() { kubectl edit service/$1; }; _'
alias keditc='_() { kubectl edit cm/$1; }; _'
alias keditds='_() { kubectl edit ds/$1; }; _'
alias klog='kubectl logs -f'
#alias klogp='_() { kubectl logs -f pod/$1; }; _'
#alias klogd='_() { kubectl logs -f deployment/$1; }; _'
alias klogj='_() { kubectl logs -f job/$1; }; _'
alias kdes='kubectl describe'
alias kdesp='kubectl describe pod'
alias kdesd='kubectl describe deployment'
alias kdess='kubectl describe service'
alias kdesi='kubectl describe ingress'
alias kdesj='kubectl describe job'
alias kdesc='kubectl describe cm'
#alias kdel='kubectl delete'
alias kexec='_() { kubectl exec $1 -- ${@:2}; }; _'
alias kbash='_() { kubectl exec -it $1 -- sh; }; _'
alias kexp='kubectl get -o yaml'
alias kpog='kubectl get pods | egrep '
alias kscale='kubectl scale --replicas='
alias kscaleup='kubectl scale --replicas=1'
alias kscaledown='kubectl scale --replicas=0'

function kdel() {
  printf "You are going to delete \033[31m $1 \033[0m from \033[31m %s \033[0m\n" "$(kubectx -c)/$(kubens -c)"
  printf >&2 '%s ' 'Continue  ? (y/n)'
  read ans
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

function kevents() {
  for res in ${@:1}; do
    echo "Events from $1 $res:"
    kubectl describe $1 $res | sed -n '/Events:/, $p'
    echo ""
  done
}

function knpod() {
  echo
  for res in ${@}; do
    echo "Events from Node: $res"
    kubectl describe node $res | sed -n '/Namespace/,/Events:/p'
    echo ""
  done
}

function ksetctx() {
  echo "Setting Namespce $2 in context $1"
  kubectl config set-context $1 --namespace=$2
  echo "Using Context $1"
  kubectl config use-context $1
}

function kenv() {
  #kubectl get pod/$1 -o json | jq '.spec.containers[].name + " " + .spec.containers[].env[].name' | column -t
  kubectl describe pod/$1 | sed -n '/Environment:/,/Mounts:/p'
}

function kenva() {
  kubectl get pods -o json | jq '.items[].metadata.name + " " + .items[].spec.containers[].name + " " + .items[].spec.containers[].env[].name + " " + .items[].spec.containers[].env[].value' | column -t
}

function kdelp() {
  for name in $*; do
    kubectl delete pod $name
  done
}

alias kdelpi="kubectl get pods | egrep -v 'Running|Completed|Pending' |grep -v NAME| cut -d' ' -f1 | xargs kubectl delete pod"

# function kdelpi(){
#     for name in $(kubectl get pods | egrep -v 'Running|Completed|Pending' |grep -v NAME| cut -d' ' -f1 | tr "\n" " ");do
#       kubectl delete pod $name
#     done
# }

function kbackup() {
  K8S_NS=$(helm list -o yaml | yq '.[].namespace')
  CHART=$(helm list -o yaml | yq '.[].chart')
  VER=$(helm list -o yaml | yq '.[].revision')
  RANDOM_STR=$(cat /dev/urandom | env LC_ALL=C tr -dc 'a-z0-9' | head -c 8)
  velero backup create ${K8S_NS}-${RANDOM_STR} --include-namespaces ${K8S_NS} -n velero -l "${CHART}--${VER}"
}

function krestore() {
  BACKUP=$1
  if [ -z $2 ]; then
    K8S_NS=$(helm list -o yaml | yq '.[].namespace')
  else
    K8S_NS=$2
  fi
  velero restore create --include-namespaces ${K8S_NS} --from-backup $BACKUP
}

function kgsecret() {
  kubectl get secret $1 -o "jsonpath={.data['${2/./\\.}']}" | base64 -d
}
