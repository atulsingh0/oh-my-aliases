#################################
#        ASCIINEMA
#################################

#!/bin/sh

arec() {
  asciinema rec $1
}

aup() {
  asciinema auth &&
    asciinema upload $*
}

aplay() {
  asciinema play $*
}

agif() {

  curpath=$PWD 
  dir=$(dirname $1)
  file=$(basename $1)
  outfile="${file%.cast}.gif"

  cd $dir 
  
  if enable_plugin docker; then 
    docker run --rm -it -u $(id -u):$(id -g) -v $PWD:/data datagenx/agg:latest $file $outfile \
    && echo "asciinema: asciicast saved to $dir/$outfile"
  elif enable_plugin podman; then 
    podman run --rm -it -v $PWD:/data datagenx/agg:latest $file $outfile \
    && echo "asciinema: asciicast saved to $dir/$outfile"
  else 
    echo "Either docker or podman is required."
  fi

  cd $curpath
}
