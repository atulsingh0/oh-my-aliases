#/bin/sh 

##
##  Aliases for GPG command
## 


alias gpgl="gpg --list-keys --keyid-format=long"
alias gpgsl="gpg --list-secret-keys --keyid-format=long"
alias gpgv="gpg --verify"
alias gpgc="gpg --clearsign"
alias gpgenc="gpg --encrypt"
alias gpgdec="gpg --decrypt"
alias gpgimp="gpg --import"
alias gpgimps="gpg --allow-secret-key-import --import"
alias gpgdel="gpg --delete-key"
alias gpgdels="gpg --delete-secret-key"

gpgverbose() {
  gpg --export "$1" | gpg --list-packets --verbose
}

gpgexp() {
  gpg -ao "$1.pub.gpg" --export "$1" 
}

gpgexps() {
  gpg -ao "$1.secret-key.gpg" --export-secret-key "$1"
}


get_gpg_algorithm_name() {
   local n="${1}"
   local xml=$(curl -X GET -o - -L -s "https://www.iana.org/assignments/openpgp/openpgp.xml")
   if [ "$?" != "0" ]; then
     echo -e "unknown algorithm (list not loaded)"
     return
   fi
  
   local xpath="/reg:registry/reg:registry[@id='openpgp-public-key-algorithms']/reg:record[reg:value='${n}']/reg:description"
   local name=$( echo -e "${xml}" | xmlstarlet sel -N reg=http://www.iana.org/assignments -t -v "${xpath}" )
   if [ "$?" != "0" ]; then
     echo -e "unknown algorithm (number not found)"
     return
   fi
  
   echo -e "${name}"
}
