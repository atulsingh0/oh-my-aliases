#!/bin/sh
#################################
#        git
#################################

git config --global pull.rebase true
git config --global pull.ff true

alias gs='git status'
alias gss='git status --short'
alias gp1='git pull'
alias gp2='git push'
alias gb="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
alias gbc='git branch --show-current'
alias gco='git checkout'
alias gacm='git commit -am'
alias gcma='git commit --amend'
alias gcf='git commit --fixup'
alias gdiff='git diff'
alias glog='git log --oneline --abbrev-commit -30'
alias gsave='git add -A && git commit -m "chores: save checkpoint"'
alias gsts='git stash -m'
alias gstsl='git stash list'
alias gchange='git show --pretty="" -r'
alias gfile='git diff-tree --no-commit-id --name-only -r'
alias gcme='git commit --allow-empty -m "Trigger Build, Empty commit"'
alias gaa='git add --all'

gtst() {
  git add .
  git commit --amend
  git push -f
}

ga() {
  grep -Er '<<<<<<< HEAD|>>>>>>>' "$@"
  count=$(grep -Er '<<<<<<< HEAD|>>>>>>>' "$@" | grep -vc "0$")
  # echo $count
  if [ "${count}" -gt 0 ]; then
    echo "Fix the conflicts."
  else
    git add "$@"
  fi
}

gcm() {
  BR=$(git branch --show-current | sed "s_integration/__" | sed -e "s/\(.*[0-9]\).*/\1/g" | sed "s_server_SERVER_")
  echo "current branch: $BR"
  git commit -m "$BR | $*"
}

gfix() {
  commit="$1"
  git commit --fixup="${commit}"
  git stash
  git rebase -i --autosquash "${commit}"~
  git stash pop
  echo "Use 'git push -f' to force push the changes."
}

gbren() {
  cur=$(git branch --show-current)
  new="$1"
  git branch -m "${cur}" "${new}"
  git branch --unset-upstream
  git push --set-upstream origin :"${cur}" "${new}"
}
