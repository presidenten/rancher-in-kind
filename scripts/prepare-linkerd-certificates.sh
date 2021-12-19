#!/bin/bash

CERTS_DIR=$1
CERT_TIME=$2

docker image pull smallstep/step-cli
docker image pull ubuntu
rm -rf $CERTS_DIR

CREATE_TRUST_ANCHOR_CERT="step certificate create root.linkerd.cluster.local ca.crt ca.key --profile root-ca --no-password --insecure"
CREATE_ISSUER_CERT="step certificate create identity.linkerd.cluster.local issuer.crt issuer.key --profile intermediate-ca --not-after ${CERT_TIME}h --no-password --insecure --ca ca.crt --ca-key ca.key"
docker run --rm -v "$(pwd)/$CERTS_DIR":/app -w /app smallstep/step-cli $CREATE_TRUST_ANCHOR_CERT
docker run --rm -v "$(pwd)/$CERTS_DIR":/app -w /app smallstep/step-cli $CREATE_ISSUER_CERT

CERT_EXPIRY=$(docker run --rm ubuntu date -d "+${CERT_TIME} hour" +"%Y-%m-%dT%H:%M:%SZ")
echo $CERT_EXPIRY > ./$CERTS_DIR/cert_expiry
