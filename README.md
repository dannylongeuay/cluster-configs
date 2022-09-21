# Cluster Configs

This repo contains configurations for Kubernetes clusters.

## Local Development

Local development leverages [K3D](https://k3d.io/) to create a local Kubernetes cluster. 

[Kubectl](https://kubernetes.io/docs/tasks/tools/) and [FluxCLI](https://fluxcd.io/docs/installation/#install-the-flux-cli) are used to bootstrap the cluster. 

The built-in [Traefik](https://doc.traefik.io/traefik/) ingress controller is used to proxy the application endpoints.

URL endpoints:
TODO

### Requirements

- [ASDF-VM](https://asdf-vm.com/)
- [Docker](https://www.docker.com/)

### Usage

Run `make create` to create the local Kubernetes cluster and bootstrap Flux.

### Make Targets

```
TODO
```
