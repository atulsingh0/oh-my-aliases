#/bin/sh 

##
##  Aliases for GPG command
## 


gpgl() {
  case $1 in 
    l)
      shift
      gpg --list-keys --keyid-format=long "$@"
      ;;
    s)
      shift
      gpg --list-keys --keyid-format=short "$@"
      ;;
    *)
      gpg --list-keys
      ;;
  esac
}

gpgsl() {
  case $1 in 
    l)
      shift
      gpg --list-secret-keys --keyid-format=long "$@"
      ;;
    s)
      shift
      gpg --list-secret-keys --keyid-format=short "$@"
      ;;
    *)
      gpg --list-secret-keys
      ;;
  esac
}
