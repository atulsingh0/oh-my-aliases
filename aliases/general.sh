alias ll="ls -lrt"
if command -v batcat >/dev/null 2>&1; then
  alias bat=batcat
fi

if command -v nvim >/dev/null 2>&1; then
  alias vi=nvim
fi

if command -v python3 >/dev/null 2>&1; then
  alias python=python3
fi

if command -v most >/dev/null 2>&1; then
  export PAGER=most
fi
