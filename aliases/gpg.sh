#/bin/sh 

##
##  Aliases for GPG command
## 


gpgl() {
  if [ -z $1 ]; then 
    gpg --list-keys
  fi 
  
  if [ $1 == 'l' ]; then 
    gpg --list-keys --keyid-format=long $2
  elif [ $1 == 's' ]; then
    gpg --list-keys --keyid-format=short $2
  fi
}

gpgsl() {
  if [ -z $1 ]; then 
    gpg --list-secret-keys
  fi 

  if [ $1 == 'l' ]; then 
    gpg --list-secret-keys --keyid-format=long $2
  elif [ $1 == 's' ]; then
    gpg --list-secret-keys --keyid-format=short $2
  fi
}
