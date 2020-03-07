#!/bin/bash

if [ -z $1 ]; then
    echo "Supply an interface to target (default is port 443, tcp, TLSA EE, SHA256 hash)"
    exit 1
fi

FQDN=$1
FQDN=$(echo $1 | tr "A-Z" "a-z")
SHA256="shasum -a 256"


function run() {
    FQDN=$1
    PORT=$2

    if [ $PORT -eq 25 ]; then
        HASH=$(echo | \
            timeout 5 openssl s_client -connect ${FQDN}:${PORT} -servername ${FQDN} -starttls smtp 2>/dev/null | \
                openssl x509 -pubkey -noout 2>/dev/null | \
                openssl rsa -pubin -outform DER 2>/dev/null | \
                ${SHA256} | \
                tr "a-z" "A-Z" | cut -d" " -f 1)
    else
        HASH=$(echo | \
            timeout 5 openssl s_client -connect ${FQDN}:${PORT} -servername ${FQDN} 2>/dev/null | \
                openssl x509 -pubkey -noout 2>/dev/null | \
                openssl rsa -pubin -outform DER 2>/dev/null | \
                ${SHA256} | \
                tr "a-z" "A-Z" | cut -d" " -f 1)
    fi
    RC=$?
    if [ $RC -ne 0 ]; then
        echo failed
        return $RC
    fi

    # Error
    if [ $HASH = "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855" ]; then
        HASH="failed"
    fi

    echo "_${PORT}._tcp.${FQDN}.     IN TLSA     3 1 1 $HASH"
}

function dnscheck() {
    FQDN=$1
    PORT=$2

#    echo dig TLSA _${PORT}._tcp.${FQDN} +short
    dig      TLSA _${PORT}._tcp.${FQDN} +short | tail -n1
}


<font

# port 443
echo -n "Recommended configuration: "
run $FQDN 443

echo -n "Current DNS configuration: "
echo -n "_${PORT}._tcp.${FQDN}. IN TLSA "
dnscheck $FQDN 443
echo


# port 25
echo -n "Recommended configuration: "
run $FQDN 25

echo -n "Current DNS configuration: "
echo -n "_${PORT}._tcp.${FQDN}. IN TLSA "
dnscheck $FQDN 25
echo


