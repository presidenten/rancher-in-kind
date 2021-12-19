#!/bin/bash

CERTS_DIR=certs
CERT_TIME=87600

LINKERD_INSTALLED=$(helm ls | grep '^linkerd\s')
if [[ ! $LINKERD_INSTALLED ]]; then
  sh ./scripts/prepare-linkerd-certificates.sh $CERTS_DIR $CERT_TIME
fi

helm upgrade --install linkerd \
     --set-file linkerd2.identityTrustAnchorsPEM=$CERTS_DIR/ca.crt \
     --set-file linkerd2.identity.issuer.tls.crtPEM=$CERTS_DIR/issuer.crt \
     --set-file linkerd2.identity.issuer.tls.keyPEM=$CERTS_DIR/issuer.key \
     --set linkerd2.identity.issuer.crtExpiry=$CERT_TIME \
     ./charts/linkerd

kubectl -n linkerd wait --for=condition=Ready --timeout=120s pod --all

linkerd check

helm upgrade --install linkerd-viz ./charts/linkerd-viz

kubectl -n linkerd-viz wait --for=condition=Ready --timeout=120s pod --all
# kubectl -n linkerd-viz get pods |  awk 'NR!=1' | awk '{print $1;}' | xargs kubectl -n linkerd-viz delete pod
# kubectl -n linkerd-viz wait --for=condition=Ready pod --all

linkerd viz check
