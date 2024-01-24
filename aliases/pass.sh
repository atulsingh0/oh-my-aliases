#!/bin/sh

##############################
# Pass Command aliases - https://www.passwordstore.org/
##############################

alias padd='pass insert -m'
alias prm='pass rm'
alias pcp='pass -c'
alias pgen='pass generate dummy/pass'
alias pp1='cd ~/.password-store && git pull && cd -'
alias pp2='cd ~/.password-store && git pull && git push && cd -'
alias pupdate='pass update -m'
