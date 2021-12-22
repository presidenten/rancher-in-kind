#!/bin/bash

helm upgrade --install \
     --create-namespace -n ingress-controller \
     ingress-controller \
     ./charts/ingress-controller
