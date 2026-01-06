#!/usr/bin/env sh

#################################
#        AWS
#################################

aws_who() {
  aws sts get-caller-identity
}

# https://osoco.es/thoughts/2018/04/shell-aliases-for-accessing-your-aws-ec2-instances-via-ssh/

## Runs AWS CLI using given profile, and uses "--no-include-email" if we try to
## run ecr get-login.
## Parameters:
## -> 1: The AWS profile.
## Returns:
## - The result of running AWS CLI.
## Example:
##   awss "prof1" ecr get-login
awss() {
  [ $# -lt 2 ] && echo "Usage: awss profile cmd+" && return 1
  local profile="${1}"
  shift
  local first="${1}"
  local second=""
  if [ $# -ge 2 ]; then
    shift
    second="${1}"
  fi
  shift
  local aux=""

  if [[ "${first}" == "ecr" ]] && [[ "${second}" == "get-login" ]]; then
    aux="--no-include-email"
  fi

  aws --profile "${profile}" "${first}" "${second}" "${aux}" $@
}

## Retrieves the list of AWS Profiles already configured,
## based on the contents of ${HOME}/.aws/config.
## Returns:
## - 0 If the profiles were found; 1 otherwise.
## Example:
##   if aws_profile; do
##     for profile in ${RESULT}; do
##       echo "AWS Profile found: ${profile}";
##     done
##   fi
aws_profile() {
  local -i rescode
  local result="$(cat ${HOME}/.aws/config | grep '\[profile ' | sed 's|\[profile ||g' | tr -d ']')"
  rescode=$?

  if [ ${rescode} -eq 0 ]; then
    export RESULT="${result}"
    echo $RESULT
  fi

  return ${rescode}
}

## Set AWS profile
aws_set_profile() {
  export AWS_PROFILE="$1"
  echo "Setting AWS profile = ${AWS_PROFILE}"
}

## Set AWS region
aws_region() {
  export AWS_DEFAULT_REGION="$1"
  echo "Setting AWS REGION - ${AWS_DEFAULT_REGION}"
}

## Declares shell aliases to run awss for each AWS profile found.
## Parameters:
## - 1: The file to write the aliases to.
## Returns:
## - 0 If any shell alias was created; 1 otherwise.
## Example:
##   if generate-aws-profile-aliases ${HOME}/my-aliases; then
##     echo "AWS profile aliases generated successfully in ${HOME}/my-aliases.";
##   fi
generate_aws_profile_aliases() {
  local -i rescode=1
  local file="${1}"

  [ -z "${file}" ] && echo "Usage: generate-aws-profile-aliases [file]" && return ${rescode}
  if [ ! -e "${file}" ]; then
    touch "${file}"
    [ $? -ne 0 ] && echo "Error: Cannot write to ${file}" && return ${rescode}
  fi
  local p

  echo -n "Generating AWS profile aliases ... "
  if aws_profile; then
    local oldIFS="${IFS}"
    IFS=$' \t\n'
    if [ ${ZSH_VERSION} ]; then
      setopt sh_word_split
    fi
    for p in ${RESULT}; do
      echo "alias aws_${p}=\"awss ${p}\";" >>${file}
      rescode=0
    done
    IFS="${oldIFS}"
  fi
  echo "done"

  return ${rescode}
}

aws_s3_rb() {
  for name in "$@"; do
    aws s3 rb s3://"${name}"
  done
}


aws_s3_list_empty() {
  for name in $(aws s3 ls | cut -d' ' -f3); do
    out=$(aws s3 ls s3://"${name}" | wc -l)
    [ "${out}" -eq 0 ] && echo "$name"
  done
}


## Retrieves the running EC2 instances.
## Parameters:
## - 1: The AWS profile.
## Returns:
## - 0 If the EC2 instances could be listed; 1 Otherwise.
## - RESULT: A space-separated list with the names of the EC2 instances.
## Example:
##   if aws_ec2_list_instances "prof1"; then
##     local oldIFS="${IFS}";
##     IFS=$' \t\n';
##     if [ ${ZSH_VERSION} ]; then
##       setopt sh_word_split
##     fi
##     for i in ${RESULT}; do
##       echo "EC2 instance: ${i}"
##     done
##     IFS="${oldIFS}";
##   fi
aws_ec2_list_instances() {
  local -i rescode=1
  local profile="${1}"

  [ -z "${profile}" ] && echo "Usage: aws_ec2_list_instances <aws-profile>" && return ${rescode}

  # local result="$(aws --profile ${profile} ec2 describe-instances  --filters "Name=instance-state-name,Values=running" --query "Reservations[].Instances[]" 2>/dev/null | jq ".[] | select(.State.Name = \"running\") | .Tags[] | select(.Key == \"Name\") | .Value" | tr -d '"')"
  # rescode=$?

  # if [ ${rescode} -eq 0 ]; then
  #   export RESULT="${result}"
  #   echo $RESULT
  # fi

  aws --profile ${profile} ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[].Instances[].[InstanceId,Tags[?Key==`Name`].Value|[0],PublicIpAddress,PrivateIpAddress]' \
  --output table

  return $?
}


aws_ec2_terminate() {
  local profile="${1}"
  local instanceName="${2}"

  [ -z "${profile}" ] && echo "Usage: aws_ec2_terminate <aws-profile> <instance_name>" && return ${rescode}
  [ -z "${instanceName}" ] && echo "Usage: aws_ec2_terminate <aws-profile> <instance_name>" && return ${rescode}

  aws --profile ${profile} ec2 describe-instances \
  --filters "Name=tag:Name,Values=${instanceName}" "Name=instance-state-name,Values=running" \
  --query 'Reservations[].Instances[].[InstanceId]' --output text \
  | xargs -r aws --profile ${profile} ec2 terminate-instances --instance-ids 
  #rescode=$?

  #return ${rescode}
}

aws_ec2_terminate_ids() {
  local profile="${1}"
  local instanceIds="${*:2}"

  [ -z "${profile}" ] && echo "Usage: aws_ec2_terminate <aws-profile> <instance_ids>" && return ${rescode}
  [ -z "${instanceIds}" ] && echo "Usage: aws_ec2_terminate <aws-profile> <instance_ids>" && return ${rescode}

  aws --profile ${profile} ec2 terminate-instances --instance-ids ${instanceIds}
  #rescode=$?

  #return ${rescode}
}


## Retrieves the IP of given EC2 instance.
## Parameters:
## - 1: The instance name.
## - 2: The name of the AWS profile.
## Returns:
##   0: If the IP was found;
##   1: Otherwise
## Example:
##   if aws_ec2_get_ip nginx prof1; then
##     echo "IP of nginx in prof1: ${RESULT}";
##   fi
aws_ec2_get_ip() {
  local -i rescode=1
  local profile="${1}"
  local resource="${2}"

  [ -z "${resource}" ] && echo "Usage: aws_ec2_get_ip <aws-profile> [resource]" && return ${rescode}
  [ -z "${profile}" ] && echo "Usage: aws_ec2_get_ip <aws-profile> [resource]" && return ${rescode}

  local result="$(aws --profile ${profile} ec2 describe-instances --query "Reservations[].Instances[]" 2>/dev/null | jq ".[] | select(.Tags[].Value | test(\"^${resource}$\"; \"i\")) | .PublicIpAddress" | sort | uniq | grep -v null | tr -d '"' )"
  rescode=$?

  if [ ${rescode} -eq 0 ]; then
    export RESULT="${result}"
    echo $RESULT
  else
    export RESULT=""
  fi

  return ${rescode}
}

## Adds a new route to given IP, using given VPN interface.
## Parameters:
## - 1: The vpn interface.
## - 2: The IP address.
## Returns:
## - 0 If the route was created; 1 otherwise.
## Example:
##   if add-route-to-host tun0 8.8.8.8; then
##     echo "Route created successfully";
##   fi
add_route_to_host() {
  local vpnInterface="${1}"
  local ip="${2}"
  local -i rescode=1

  [ -z "${vpnInterface}" ] && echo "Usage: add-route-to-host [vpn-interface] [ip]" && return ${rescode}
  [ -z "${ip}" ] && echo "Usage: add-route-to-host [vpn-interface] [ip]" && return ${rescode}

  ifconfig ${vpnInterface} >/dev/null 2>&1
  rescode=$?

  if [ ${rescode} -eq 0 ]; then
    sudo route add -host ${ip} ${vpnInterface} >/dev/null 2>&1
    rescode=$?
    echo
    "Error: No interface ${vpnInterface} found"
  fi

  return ${rescode}
}

## Updates the SSH client configuration to connect to given EC2 instance.
## Parameters:
## - 1: The resource name.
## - 2: The name of the AWS profile.
## - 3: The IP. Optional.
## Environment variables:
## - AWS_VPN_INTERFACE: The name of the interface to be use to route all traffic
##   to the AWS resource. This is usually needed when your SecurityGroups include
##   specific CIDRs.
## Returns:
##   0: If the configuration has been updated successfully;
##   1: if the parameters are invalid;
##   2: If the configuration wasn't changed for some reason.
## Example:
##   if update-ec2-ssh nginx clientX; then
##     echo "SSH configuration for nginx (pre) in clientX account updated successfully";
##   fi
aws_ec2_update_ssh() {
  local -i rescode=1
  local resource="${1}"
  local profile="${2}"
  local ip="${3}"

  [ -z "${resource}" ] && echo "Usage: aws_ec2_update_ssh [resource] <aws-profile>" && return ${rescode}
  [ -z "${profile}" ] && echo "Usage: aws_ec2_update_ssh [resource] <aws-profile>" && return ${rescode}
  for s in jq ssh-keygen ssh-keyscan; do
    which ${s} 2>/dev/null >/dev/null
    rescode=$?
    if [ ${rescode} -ne 0 ]; then
      echo "Skipping update-ec2-ssh"
      return ${rescode}
    fi
  done

  local file="${HOME}/.ssh/${profile}-${resource}.config"
  if [ -z "${ip}" ]; then
    echo -n "Retrieving ${resource}'s IP ... "
    if aws_ec2_get_ip "${resource}" "${profile}"; then
      ip="${RESULT}"
      echo "${ip}"
      rescode=0
    else
      echo "Failed"
      echo "Error: Cannot retrieve ${resource}'s IP address (using ${profile} profile)"
      return ${rescode}
    fi
  fi

  if [ -e ${file} ]; then
    if [ -z "${ip}" ]; then
      ip="$(grep Hostname ${file} | awk '{print $2;}')"
    fi
  else
    cat <<EOF >${file}
Host ${profile}-${resource}
  User ec2-user
  StrictHostKeyChecking no
  IdentityFile ~/.ssh/${profile}.pem
  Hostname ${ip}
EOF
    ssh-keygen -R ${ip} >/dev/null 2>/dev/null
    ssh-keyscan -H ${ip} >>${HOME}/.ssh/known_hosts 2>/dev/null
    head -n -1 ${file} >/tmp/.${resource}.config
    echo "  Hostname ${ip}" >>/tmp/.${resource}.config
    mv -f /tmp/.${resource}.config ${file}
    rm -f ${HOME}/.ssh/config
    cat ${HOME}/.ssh/*.config >${HOME}/.ssh/config
  fi

  which xclip 2>/dev/null >/dev/null && echo -n ${ip} | xclip
  echo -n "Adding route for ${ip} ... "
  add-route-to-host "${AWS_VPN_INTERFACE}" "${ip}" 2>/dev/null >/dev/null
  echo "done"

  return ${rescode}
}

## Generates the EC2 SSH aliases for a given profile in a file.#
## Parameters:
## - 1: The AWS profile name.
## - 2: The file to write the aliases to.
## Returns:
## - 0 If the SSH alias get generated; 1 Otherwise.
## Example:
##   if generate-ec2-ssh-aliases-for-profile "prof1" ${HOME}/my-aliases; then
##     echo "SSH aliases generated for your EC2 instances in prof1, in ${HOME}/my-aliases.";
##   fi
generate_ec2_ssh_aliases_for_profile() {
  local -i rescode=1
  local profile="${1}"
  local file="${2}"
  local i
  local ip

  [ -z "${profile}" ] && echo "Usage: generate-ec2-ssh-aliases-for-profile <aws-profile> [file]" && return ${rescode}
  [ -z "${file}" ] && echo "Usage: generate-ec2-ssh-aliases-for-profile <aws-profile> [file]" && return ${rescode}
  if [ ! -e "${file}" ]; then
    echo -n >"${file}"
    if [ $? -ne 0 ]; then
      echo "Error: Cannot write to ${file}"
      echo "Usage: generate-ec2-ssh-aliases-for-profile <aws-profile> [file]"
      return ${rescode}
    fi
  fi

  echo -n "Retrieving the list of EC2 instances for profile ${profile} ... "
  if aws_ec2_list_instances "${profile}"; then
    echo "done"
    local oldIFS="${IFS}"
    IFS=$' \t\n'
    if [ ${ZSH_VERSION} ]; then
      setopt sh_word_split
    fi
    for i in ${RESULT}; do
      echo -n "Retrieving IP for ${i}: "
      if aws_ec2_get_ip ${i} ${profile}; then
        ip="${RESULT}"
        echo "${ip}"
        echo "alias ${profile}-${i}-ip=\"echo -n ${ip} | xclip 2> /dev/null; echo ${ip}\";" >>${file}
        echo "alias ssh-${profile}-${i}=\"add-route-to-host "${AWS_VPN_INTERFACE}" "${ip}" > /dev/null 2>&1; ssh ${profile}-${i} || (update-ec2-ssh ${i} ${profile} ${ip}; ssh ${profile}-${i} || (update-ec2-ssh ${i} ${profile}; ssh ${profile}-${i}))\";" >>${file}
        update-ec2-ssh ${i} ${profile} ${ip}
      fi
    done
    IFS="${oldIFS}"
  fi
}

## Generates EC2 SSH aliases for all AWS profiles in a file.
## Parameters:
## - 1: The file to write the aliases to.
## Returns:
## - 0 If the aliases get generated correctly; 1 Otherwise.
## Example:
##   if generate-all-ec2-ssh-aliases ${HOME}/my-aliases; then
##     echo "Shell aliases generated for all AWS profiles in ${HOME}/my-aliases."
##   fi
generate_all_ec2_ssh_aliases() {
  local -i rescode=1
  local file="${1}"
  local awsProfiles

  [ -z "${file}" ] && echo "Usage: generate-all-ec2-ssh-aliases [file]" && return ${rescode}
  [ ! -e "${file}" ] && echo -n >"${file}"
  if [ ! -e "${file}" ]; then
    echo -n >"${file}"
    if [ $? -ne 0 ]; then
      echo "Error: Cannot write to ${file}"
      echo "Usage: generate-all-ec2-ssh-aliases [file]"
      return ${rescode}
    fi
  fi

  echo -n "Retrieving AWS profiles ... "
  if aws_profile; then
    echo "done"
    local oldIFS="${IFS}"
    IFS=$' \t\n'
    if [ ${ZSH_VERSION} ]; then
      setopt sh_word_split
    fi
    for awsProfile in ${RESULT}; do
      if generate-ec2-ssh-aliases-for-profile "${awsProfile}" "${file}"; then
        rescode=0
      else
        rescode=1
        break
      fi
    done
    echo "Regenerated SSH configurations for all EC2 instances in ${file}"
    IFS="${oldIFS}"
  fi

  return ${rescode}
}

aws_decode_msg() {
  aws sts decode-authorization-message --encoded-message "$1"  | jq -r '.DecodedMessage' | jq
}

aws_ec2_instances_key() {
  aws ec2 describe-instances --query "Reservations[].Instances[].[KeyName,InstanceId]" --output text | grep -v None | column -t
}

aws_keys_instance() {
  aws ec2 describe-key-pairs --query "KeyPairs[].[KeyName]" --output text |xargs -I {} aws ec2 describe-instances --filters Name=key-name,Values={} --query "Reservations[].Instances[].[KeyName,InstanceId]" --output text
}
