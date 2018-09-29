#!/bin/bash

if [ -z $1 ]; then
    echo "Supply an interface to target (default is port 443, tcp, TLSA EE, SHA256 hash)"
    exit 1
fi

FQDN=$1
SHA256="shasum -a 256"


function run() {
    FQDN=$1
    PORT=$2

    HASH=$(echo | \
        if [ $PORT -eq 25 ]; then
            OUTPUT=$(timeout 5 openssl s_client -connect ${FQDN}:${PORT} -servername ${FQDN} -starttls smtp 2>/dev/null)
        else
            OUTPUT=$(timeout 5 openssl s_client -connect ${FQDN}:${PORT} -servername ${FQDN} 2>/dev/null)
        fi
        RC=$?
        if [ $RC -ne 0 ]; then
            echo failed
            return $RC
        fi

        echo $OUTPUT | openssl x509 -pubkey -noout 2>/dev/null | \
        openssl rsa -pubin -outform DER 2>/dev/null | \
        ${SHA256} | \
        tr "a-z" "A-Z" | cut -d" " -f 1)

    echo "_${PORT}._tcp.${FQDN}.     IN TLSA     3 1 1 $HASH"
}

run $FQDN 443
run $FQDN 25

