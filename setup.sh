#!/usr/bin/env bash
[ "$1" ] || { echo "usage: ./setup.sh <letsencrypt email>" 1>&2 ; exit 1;  }
[ -f ".env" ] || cp env.setup .env
sed -i -e "s/{{DEFAULT_EMAIL}}/$1/g" -e "s#{{NGINX_PROXY_PATH}}#$PWD#g" .env
mkdir -p $PWD/data/{certs,html,vhost.d,acme.sh,dhparam}
docker network ls | grep -q nginx-proxy || docker network create nginx-proxy
echo -n "continue with startup? " && read dummy
docker-compose -f docker-compose.yml up -d --build
echo -n "show startup logs? " && read dummy
docker-compose -f docker-compose.yml logs -f --tail 1000
