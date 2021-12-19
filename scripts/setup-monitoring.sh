#!/bin/bash

helm upgrade --install \
     --create-namespace -n cattle-monitoring-system \
     rancher-monitoring-crd \
     ./charts/monitoring-crd

helm upgrade --install \
     --create-namespace -n cattle-monitoring-system \
     rancher-monitoring \
     ./charts/monitoring

kubectl -n cattle-monitoring-system wait --for=condition=Ready pod --all

echo ""
echo "Loki will start soon, it just takes some time to get up and running"
echo ""
