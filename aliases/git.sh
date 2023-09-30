#!/bin/sh
#################################
#        git
#################################

GIT_COMMIT_BRANCH=${GIT_COMMIT_BRANCH:-true}

git config --global pull.rebase true
git config --global pull.ff true
git config --global push.autoSetupRemote true
git config --global init.defaultBranch main
git config --global status.showUntrackedFiles all
git config --global url."git@github.com:".insteadOf "https://github.com/"
git config --global url.ssh://git@github.com/.insteadOf https://github.com/

alias gs='git status'
alias grs='git restore'
alias grss='git restore --staged'
alias grv='git revert'
alias gss='git status --short'
gp1() {
  git update-index -q --ignore-submodules --refresh
  sts=0
  if ! git diff-files --quiet --ignore-submodules --; then
     echo "Stashing files.."
     git stash
     sts=1
  fi
  git fetch origin
  git pull origin

  if [ $sts -gt 0 ]; then 
     echo "Un-stashing files..."
     git stash pop
  fi
}
alias gp2='git push origin $(git branch --show-current)'
alias gb="git branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate"
alias gbc='git branch --show-current'
alias gco='git fetch origin && git checkout'
alias gcma='git commit --amend'
alias gcf='git commit --fixup'
alias gdif='git diff'
alias glog="git log --pretty=format:'%C(magenta)%h%Creset -%C(red)%d%Creset %s %C(green)(%cr) %C(green)<%an>%Creset' --abbrev-commit -30"
alias glg="git log --pretty=format:'%C(magenta)%h%Creset -%C(red)%d%Creset %s %C(green)(%cr) %C(green)<%an>%Creset' --abbrev-commit"
#alias glg='git log --oneline --abbrev-commit'
#alias glog='git log --oneline --abbrev-commit -30'
alias glog1='git log --oneline --decorate --graph --all -30'
alias gtree='git log --graph --abbrev-commit --decorate --date=relative --format=format:'\''%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'\'' --all'
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
alias gremote='git remote set-url origin'

gsend() {
    git commit -am "$1" && git push
}

gs1() {
  awk -vOFS='' '
    NR==FNR {
        all[i++] = $0;
        difffiles[$1] = $0;
        next;
    }
    ! ($2 in difffiles) {
        print; next;
    }
    {
        gsub($2, difffiles[$2]);
        print;
    }
    END {
        if (NR != FNR) {
            # Had diff output
            exit;
        }
        # Had no diff output, just print lines from git status -sb
        for (i in all) {
            print all[i];
        }
    }
' \
    <(git diff --color --stat=$(($(tput cols) - 3)) HEAD | sed '$d; s/^ //')\
    <(git -c color.status=always status -sb)
}

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

# gcma() {
#   git add $*
#   git commit --amend
#   echo "Use 'git push -f' to force push the changes."
# }

ga() {
  # --exclude=*.{tar,tar.gz} --exclude-dir={.terraform}
  if [ "$1" != "." ]; then
    files=$(echo $* | tr " " "\n")
    echo "$files" | while read -r file; do
      grep -ERl --exclude-dir=".terraform" '<<<<<<< HEAD|>>>>>>>' "$file"
      count=$(grep -ERl --exclude-dir=".terraform" '<<<<<<< HEAD|>>>>>>>' "$file" | grep -vc "0$")
      # echo $count
      if [ "${count}" -gt 0 ]; then
        echo "Fix the conflicts in $file" && break
      fi
        git add "$file"
      done
  else
    git add .
  fi
}

gcm() {
if ${GIT_COMMIT_BRANCH}; then
  BR=$(git branch --show-current | sed "s_integration/__" | cut -d'-' -f1,2 | sed "s_server_SERVER_")
  #BR=$(git branch --show-current | sed "s_integration/__" | sed -e "s/\(.*[0-9]\).*/\1/g" | sed "s_server_SERVER_")
  echo "current branch: $BR"
  git commit -m "$BR | $*"
else
  git commit -m "$*"
fi
}

gfix() {
  # Fix a commit
  commit="$1"
  git commit --fixup="${commit}"
  git stash
  git rebase -i --autosquash "${commit}"~
  git stash pop
  echo "Use 'git push -f' to force push the changes."
}

gbren() {
  # Branch Rename
	cur=$(git branch --show-current)
	new="$1"
  echo "Renaming git branch from $cur to $new"
  git branch -m "${cur}" "${new}"
  git push origin ":${cur}" "${new}"
  git branch --unset-upstream
  git branch --set-upstream-to=origin/$new $new
}

gcopy() {
  # Copy File from one branch to another
  echo "Copying ${@:2} from branch $1"
  git checkout "$1" -- "${@:2}"
}

fix_gitignore(){
  git rm -r --cached .
  git add .
  git commit -m ".fixing gitignore"
}

gfilec() {
  # Commit on a file
  git rev-list HEAD -- "$@"
}

gdifc() {
  # Changes done in a commit 
  git diff "$1"~ "$1"
}
