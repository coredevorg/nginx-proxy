#!/usr/bin/env bash
[ "$1" ] || { echo "usage: ./setup.sh <email>" 1>&2 ; exit 1;  }
[ -f ".env" ] || cp env.setup .env
sed -i -e "s/{{DEFAULT_EMAIL}}/$1/g" -e "s#{{NGINX_PROXY_PATH}}#$PWD#g" .env
mkdir -p $PWD/data/{certs,html,vhosts.d,acme.sh,dhparam}
docker network ls | grep -q nginx-proxy || docker network create nginx-proxy
