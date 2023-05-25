gcp_lets() {

  if [ $# -lt 2 ]; then
    echo "Usgae: gcp_lets <email> <fqdn> [fqdn|fqdn]"
  else
    email="$1"
    fqdn="${*:2}"

    # create dir
    mkdir -p ~/certs/etc ~/certs/var
    [ ! -f ~/.config/gcloud/application_default_credentials.json ] && gcloud auth application-default login

    fqdns=$(echo "${fqdn}" | sed 's/ / -d /g' | sed 's/^/-d /')

    docker run --platform=linux/amd64 --rm --name certbot \
      -v ~/certs/etc:/etc/letsencrypt \
      -v ~/certs/var/:/var/lib/letsencrypt \
      -v ~/.config/gcloud/application_default_credentials.json:/credentials.json \
      certbot/dns-google \
      certonly --dns-google \
      "${fqdns}" \
      --dns-google-credentials /credentials.json \
      --dns-google-propagation-seconds 90 --agree-tos \
      -m "${email}" --non-interactive
  fi
}
