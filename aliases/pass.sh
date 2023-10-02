#!/bin/sh

##############################
# Pass Command aliases - https://www.passwordstore.org/
##############################

alias padd='pass insert -m'
alias prm='pass rm'
alias pcp='pass -c'
alias pgen='pass generate dummy/pass'
alias ppush='cd ~/.password-store && git push && cd -'
alias ppull='cd ~/.password-store && git pull && cd -'
