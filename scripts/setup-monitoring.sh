#!/bin/bash

helm upgrade --install \
     --create-namespace -n cattle-monitoring-system \
     rancher-monitoring-crd \
     ./charts/monitoring-crd

helm upgrade --install \
     --create-namespace -n cattle-monitoring-system \
     rancher-monitoring \
     ./charts/monitoring
