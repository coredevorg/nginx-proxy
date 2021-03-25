#!/usr/bin/env bash
[ "$1" ] || { echo "usage: ./setup.sh <emil>" 1>&2 ; exit 1;  }
[ -f ".env" ] || cp env.setup .env
sed -i "s/{{DEFAULT_EMAIL}}/$1/g" .env
mkdir -p ./data/{certs,html,vhosts.d}
