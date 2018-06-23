#!/bin/bash

if [ -z $1 ]; then
    echo "Supply an interface to target (default is port 443, tcp, TLSA EE, SHA256 hash)"
    exit 1
fi

FQDN=$1
PORT=443
SHA256="shasum -a 256"


HASH=$(echo | \
    openssl s_client -connect ${FQDN}:$PORT -servername ${FQDN} 2>/dev/null | \
    openssl x509 -pubkey -noout 2>/dev/null | \
    openssl rsa -pubin -outform DER 2>/dev/null | \
    ${SHA256} | \
    tr "a-z" "A-Z" | cut -d" " -f 1)

echo "_443._tcp.${FQDN}.     IN TLSA     3 1 1 $HASH"
