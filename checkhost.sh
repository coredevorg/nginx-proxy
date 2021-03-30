#!/usr/bin/env bash
[ "$1" ] || { echo "usage: checkhost.sh <FQDN>" ; exit 1; }
HOST="$1"
CERT="$(dirname $0)/data/certs/$HOST/cert.pem"
CHECK=true
ping -q -c1 -W1 $HOST >/dev/null 2>&1 || { echo "host $HOST is not reachable" ; exit 2 ; }
echo "host $HOST is reachable"
[ -f "$CERT" ] && {
    echo "found cert $CERT"
    openssl x509 -in $CERT -text | egrep  "Not (Before|After)"
    CHECK=false ; HTTP=$(curl -s -w %{http_code} https://$HOST -o /dev/null)
    [ "$HTTP" == "200" ] && { echo "host $HOST is up and returned $HTTP" ; exit 0; }
}
[ "$CHECK" == "true" ] && echo "no existing cert found for $HOST"
echo -n "continue with container startup for $HOST?" && read dummy && echo
echo -n "waiting for container startup and certificat generation ."
CONTAINER=$(docker run --rm -e "VIRTUAL_HOST=$HOST" -e "LETSENCRYPT_HOST=$HOST" --network "nginx-proxy" -d nginx:alpine)

sleep 1 ; echo -n "." ; let timeout=30
while [ $((timeout--)) -gt 0 ]
do
    sleep 1 ; echo -n "."
    if [ "$CHECK" == "true" ]
    then
        [ -f "$CERT" ] && { echo ; echo "found cert $CERT" ; openssl x509 -in $CERT -text | egrep "Not (Before|After)" ; break; }
    else
        HTTP=$(curl -s -w %{http_code} https://$HOST -o /dev/null)
        [ "$HTTP" == "200" ] && { echo ; break; }
    fi
done
[ $timeout -gt 0 ] || { echo ; echo "certificate generation for $HOST failed!" ; } 
[ "$HTTP" ] || HTTP=$(curl -s -w %{http_code} https://$HOST -o /dev/null)
echo "server https://$HOST returned $HTTP"
docker stop "$CONTAINER" >/dev/null
