# Usage

This repo is to create rancher and add [kind](https://github.com/kubernetes-sigs/kind) (Kubernetes IN Docker) into Rancher automatically with all-in-one script.
It also installs cluster monitoring, nginx ingress controller, linkerd and linkerd-viz.

---

## Prerequisite

1) Make sure you have installed:
  - Kind (kubernetes in docker) locally.
    Installation instruction: https://kind.sigs.k8s.io/docs/user/quick-start/
  - Kubectl
    - Installation instructions: https://kubernetes.io/docs/tasks/tools/#kubectl
  - Linkerd cli
    - Installation instructions (only step 1): https://linkerd.io/2.11/getting-started/#step-1-install-the-cli
  - Helm 3
    - Installation instructions: https://helm.sh/docs/intro/install/
  - K9S
    - Installation instructions: https://k9scli.io/topics/install/
  - If m1 mac!! Docker Desktop 4.3.1 contains a bug which wont allow rancher to start
    - Download 4.2.0 here: https://docs.docker.com/desktop/mac/release-notes/#docker-desktop-420

2) Adjust docker engine memory

Default docker engine is set to use 2GB runtime memory, adjust it to 8GB+ if you can.
You also want 3-4 cpu.

3) Prepare for the local docker registry
Add this line to your hosts file (it already resolves in docker desktop for win/mac)
```bash
127.0.0.1 host.docker.internal
```
Add the insecure-registries config to your docker engine:

```
  "insecure-registries": [
    "host.docker.internal:5000"
  ],
```

4) review `kind.yaml`

Currently I only set two worker nodes, you can add one more if you need.

---

## Cluster setup and teardown
### Create the stack

```bash
./rkind.sh create
```

### Destroy the stack

```bash
./rkind.sh destroy
```

---
## Custom kind configuration

If you'd like to change the kind configuration, please update file [kind.yaml](kind.yaml). For details, go through https://kind.sigs.k8s.io/

---

## The helm charts

The helm charts includes the original charts as dependencies, adds overrides, and might add extra dependencies, like adding loki to grafana and a nodeport service to linkerd-viz.


### Changes to Rancher monitoring

- Extra dependencies (loki + promtail):
  https://github.com/presidenten/rancher-in-kind/blob/master/charts/monitoring/Chart.yaml#L8-L16

- Value overrides:
  https://github.com/presidenten/rancher-in-kind/blob/master/charts/monitoring/values.yaml

### Changes to linkerd-viz

- Helm value overrides:
  https://github.com/presidenten/rancher-in-kind/blob/master/charts/linkerd-viz/values.yaml

- Extra nodeport service:
  https://github.com/presidenten/rancher-in-kind/blob/master/charts/linkerd-viz/templates/services/linkerd-viz-nodeport.yaml

---

## Port usage

| name             | url                                            |
|------------------|------------------------------------------------|
| Rancher:         | `localhost:4443`                               |
| Docker registry: | `host.docker.internal:5000`                    |
| Linked-viz:      | `localhost:30000`                              |
| HTTP ingress:    | `localhost:30080`                              |
| HTTPS ingress:   | `localhost:30443` (self signed cert)           |
| Nodeport:        | `localhost:30001-30010` free for tcp/udp usage |

---

## Using local docker registry

```bash
docker image tag my-image:latest host.docker.internal:5000/my-image:latest
docker image push host.docker.internal:5000/my-image:latest
```
