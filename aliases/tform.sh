#!/bin/sh
#################################
#        Terraform
################################

alias tf='terraform'

tfaa() {
  if [ -z "$1" ]; then
    terraform apply --auto-approve
  else
    terraform apply --auto-approve -var-file="$1"
  fi
}

tfda() {
  if [ -z "$1" ]; then
    terraform destroy --auto-approve
  else
    terraform destroy --auto-approve -var-file="$1"
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
