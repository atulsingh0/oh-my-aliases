#!/usr/bin/env sh

#################################
#        DELTA
#################################

if which delta >/dev/null 2>&1; then
  git config --global core.pager "delta --line-numbers --dark"
fi
