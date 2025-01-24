#!/bin/sh

##############################
# Pass Command aliases - https://www.passwordstore.org/
##############################

alias padd='pass insert -m'
alias prm='pass rm'
alias pcp='pass -c'
alias pgen='pass generate dummy/pass'
alias pp1='cd ~/.password-store && git pull && cd -'
pp2() {
  cd ~/.password-store || exit
  git pull && git push origin
  git checkout master && git merge main && git push origink
  git checkout main
  cd - || exit
}

# https://github.com/roddhjav/pass-update
alias pupdate='pass update -m'

# https://github.com/atulsingh0/pass-file
alias pfadd='pass file add'
alias pfsave='pass file save'
