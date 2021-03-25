#!/usr/bin/env bash
[ "$1" ] || { echo "usage: ./setup.sh <email>" 1>&2 ; exit 1;  }
[ -f ".env" ] || cp env.setup .env
sed -i -e "s/{{DEFAULT_EMAIL}}/$1/g" .env
mkdir -p ./data/{certs,html,vhosts.d}
docker network ls | grep -q nginx-proxy || docker network create nginx-proxy
