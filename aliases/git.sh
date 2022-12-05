#################################
#        git
#################################

cur_path="$(cd "$(dirname "$0")" && pwd)"

git config --global core.excludesfile $cur_path/gitignore_global
[[ ! -f $cur_path/personal_gitignore_global ]] || git config --global core.excludesfile $cur_path/personal_gitignore_global

alias gs='git status'
alias gp1='git pull'
alias gp2='git push'
alias gb="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
alias gco='git checkout'
alias gacm='git commit -am'
alias gcma='git commit --amend'
alias gdiff='git diff'
alias glog='git log --oneline --abbrev-commit -30'
alias gsave='git add -A && git commit -m "chores: save checkpoint"'
alias gsts='git stash'
alias gstsl='git stash list'
alias gchange='git show --pretty="" -r'
alias gfile='git diff-tree --no-commit-id --name-only -r'
alias gcme='git commit --allow-empty -m "Trigger Build, Empty commit"'
alias gtst='_() { git add . && git commit --amend && git push -f; };_'

function ga() {
  egrep '<<<<<<< HEAD|>>>>>>>' $@
  count=$(egrep -c '<<<<<<< HEAD|>>>>>>>' $@ | grep -vc "0$")
  # echo $count
  if [[ $count > 0 ]]; then
    echo "Fix the merge in "
  else
    git add $@
  fi
}

function gcm() {
  BR=$(git branch --show-current | sed "s_integration/__")
  echo "current branch: $BR"
  git commit -m "$BR | $*"
}
