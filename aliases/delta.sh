#!/bin/sh
#################################
#        DELTA
#################################

if command -v delta >/dev/null 2>&1; then
  git config --global core.pager "delta --line-numbers --dark"
fi
