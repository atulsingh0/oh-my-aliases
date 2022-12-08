#################################
#        Terraform
################################

alias tf='terraform'

function tfaa() {
  if [ -z $1 ]; then
    terraform apply --auto-approve
  else
    terraform apply --auto-approve -var-file=$1
  fi
}

function tfda() {
  if [ -z $1 ]; then
    terraform destroy --auto-approve
  else
    terraform destroy --auto-approve -var-file=$1
  fi
}

function tfd() {
  if [ -z $1 ]; then
    terraform destroy
  else
    terraform destroy -var-file=$1
  fi
}

function tfp() {
  if [ -z $1 ]; then
    terraform plan
  else
    terraform plan -var-file=$1
  fi
}

function tfa() {
  if [ -z $1 ]; then
    terraform apply
  else
    terraform apply -var-file=$1
  fi
}

function tftaint() {
  for res in "$@"; do
    terraform taint $res
  done
}
