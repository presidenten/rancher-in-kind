#!/bin/bash

helm upgrade --install \
     --create-namespace -n ingress-controller \
     ingress-controller \
     ./charts/ingress-controller

kubectl -n ingress-controller rollout restart deployment ingress-controller-nginx-ingress
