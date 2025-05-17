#!/usr/bin/env sh

##############################
# Pass Command aliases - https://www.passwordstore.org/
##############################

alias padd='pass insert -m'
alias prm='pass rm'
alias pcp='pass -c'
alias pgen='pass generate dummy/pass'


# https://github.com/roddhjav/pass-update
alias pupdate='pass update -m'

# https://github.com/atulsingh0/pass-file
alias pfadd='pass file add'
alias pfsave='pass file save'


pgrep() {
  [ -n "${PASSWORD_STORE_DIR}" ] && PASS_DIR="${PASSWORD_STORE_DIR}" \
    || PASS_DIR="$HOME/.password-store/"

  tree -P '*'$1'*' "${PASS_DIR}" --prune | grep -v "directories|$PASS_DIR"
}
