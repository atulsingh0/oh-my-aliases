#!/bin/sh
#################################
#        git
#################################

git config --global pull.rebase true
git config --global pull.ff true
git config --global push.autoSetupRemote true

alias gs='git status'
alias grs='git restore'
alias grv='git revert'
alias gss='git status --short'
alias gp1='git pull'
alias gp2='git push'
alias gb="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
alias gbc='git branch --show-current'
alias gco='git checkout'
alias gcma='git commit --amend'
alias gcf='git commit --fixup'
alias gdif='git diff'
alias glg='git log --oneline --abbrev-commit'
alias glog='git log --oneline --abbrev-commit -30'
alias glog1='git log --oneline --decorate --graph --all -30'

alias gsavea='git add -A && git commit -m "chores: save checkpoint at $(date -Iseconds)"'
alias gstm='git stash -m'
alias gstl='git stash list'
alias gst1='git stash -u'
alias gst2='git stash pop'
alias gchange='git show --pretty="" -r'
alias gfile='git diff-tree --no-commit-id --name-only -r'
alias gcme='git commit --allow-empty -m "Trigger Build, Empty commit"'
alias gaa='git add --all'
alias gpatch='git format-patch'

gsave() {
  git add $@ &&
    git commit -m "chores: save checkpoint at $(date -Iseconds)"
}

gclean() {
  git remote prune origin &&
    git repack &&
    git prune-packed &&
    git reflog expire --expire=1.month.ago &&
    git gc --aggressive &&
    git fetch -p

  echo "Now .git size"
  du -sh .git
}

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
	git branch --unset-upstream || echo "No upstreme"
	git branch -D "${cur}" || echo "No upstream deletion"
	git push --set-upstream origin "${new}"
}

gcopy() {
  echo "Copying ${@:2} from branch $1"
  git checkout "$1" -- "${@:2}"
}
