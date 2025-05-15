#!/usr/bin/env sh

#################################
#        Terraform
################################

alias tf='terraform'
alias tfo='terraform output'
alias tfl='terraform state list'

tfaa() {
  if [ -z "$1" ]; then
    terraform apply --auto-approve
  else
    terraform apply --auto-approve -var-file="$1"
  fi
}

tfd() {
  if [ -z "$1" ]; then
    terraform destroy
  else
    terraform destroy -var-file="$1"
  fi
}

tfp() {
  if [ -z "$1" ]; then
    terraform plan
  else
    terraform plan -var-file="$1"
  fi
}

tfa() {
  if [ -z "$1" ]; then
    terraform apply
  else
    terraform apply -var-file="$1"
  fi
}

tftaint() {
  for res in "$@"; do
    terraform taint "${res}"
  done
}
