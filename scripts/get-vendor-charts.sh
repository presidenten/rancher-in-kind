#!/bin/bash

helm repo add linkerd https://helm.linkerd.io/stable
helm repo update

rm -rf vendor
mkdir -p vendor

# Rancher monitoring
git clone --depth=1 https://github.com/rancher/charts.git vendor/rancher-charts

# Linkerd
helm fetch --untar linkerd/linkerd2 --untardir vendor/linkerd
helm fetch --untar linkerd/linkerd-viz --untardir vendor/linkerd-viz
