#!/usr/bin/env sh

get_cci_user() {
    TOKEN="$1"
    HOST="$2"

    # setting up hosts
    if [ -z "$HOST" ]; then
        API_ENDPOINT="https://circleci.com"
        echo "Hostname defaulted to circleci.com"
    else
        API_ENDPOINT="$HOST"
    fi

    # calling CCI API in 
    echo ""
    curl --request GET \
      --url "${API_ENDPOINT}/api/v2/me" \
      --header "Circle-Token: ${TOKEN}"
}
