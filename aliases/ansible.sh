#################################
#        ANSIBLE
#################################

alias ans='ansible'
alias ailist='ansible-inventory -y --list'
alias adoc='ansible-doc'

function ahost() {
  # List host from inventory group
  groups=${@// /,}
  ansible $groups --list-hosts
}
