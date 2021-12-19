# Usage

This repo is to create rancher and add [kind](https://github.com/kubernetes-sigs/kind) (Kubernetes IN Docker) into Rancher automatically with all-in-one script.
It also installs cluster monitoring, linkerd and linkerd-viz

* Create Rancher UI
* Create Kind Kubernetes cluster
* Init rancher admin’s password
* Update server url in rancher
* Import kind cluster into rancher
* Install cluster monitoring
* Generate linkerd certificates
* Install linkerd
* Install linkerd-viz

### Notes

Rancher API keeps changing, currently we hard code the rancher version to version "v2.6.2"

### Prerequisite

1) Make sure you have installed:
  -  Kind (kubernetes in docker) locally.
     The installation instruction is here: https://kind.sigs.k8s.io/docs/user/quick-start/
  - Kubectl
  - Helm 3

2) Adjust docker engine memory

Default docker engine is set to use 2GB runtime memory, adjust it to 8GB+ if you can.

3) review `kind.yaml`

Currently I only set one worker node, you can add more if you need.

### Create the stack

```bash
$ ./rkind.sh create
```

### Destroy the stack

```bash
$ ./rkind.sh destroy
```
### Custom kind configuration

If you'd like to change the kind configuration, please update file [kind.yaml](kind.yaml). For details, go through https://kind.sigs.k8s.io/


### The helm charts

The helm charts includes the original charts as dependencies, adds overrides, and might add extra dependencies, like adding loki to grafana and a nodeport service to linkerd-viz.


#### Changes to Rancher monitoring

- Extra dependencies (loki + promtail):
  https://github.com/presidenten/rancher-in-kind/blob/master/charts/monitoring/Chart.yaml#L8-L16

- Value overrides:
  https://github.com/presidenten/rancher-in-kind/blob/master/charts/monitoring/values.yaml

#### Changes to linkerd-viz

- Helm value overrides:
  https://github.com/presidenten/rancher-in-kind/blob/master/charts/linkerd-viz/values.yaml

- Extra nodeport service:
  https://github.com/presidenten/rancher-in-kind/blob/master/charts/linkerd-viz/templates/services/linkerd-viz-nodeport.yaml
