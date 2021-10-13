# ☕Coffee Shop

This repository contains the deploy files and other useful information
for my K8s Server.

## Why Coffee Shop?
- I like Coffee!
- *therefore* my servers and devices are coffee themed
    - Espresso: Proxmox VE Server
    - Cappuccino: NAS Virtual Machine (NFS Shares right now)
    - Mocha: K3S Virtual Machine
    - Ristretto: Raspberry Pi (PiHole) **[OFFLINE]**

## Ansible
- There are ansible roles for setting up infrastructure

## Some of the notable services
- [cert-manager](https://cert-manager.io/) - SSL certificates - with Cloudflare DNS challenge
- [flux](https://toolkit.fluxcd.io/) - GitOps tool for deploying manifests from the `cluster` directory
- [hajimari](https://github.com/toboshii/hajimari) - start page with ingress discovery
- [local-path-provisioner](https://github.com/rancher/local-path-provisioner) - default storage class provided by k3s
- [metallb](https://metallb.universe.tf/) - bare metal load balancer
- [traefik](https://traefik.io) - ingress controller

A full list with services will be available soon on my blog:
[](https://jonathanbartlett.co.uk) so subscribe over there or check back here if
you are interested.

## pre-commit
It is advisable to install [pre-commit](https://pre-commit.com/)
and the pre-commit hooks that come with this repository.
[sops-pre-commit](https://github.com/k8s-at-home/sops-pre-commit) will check to
make sure you are not by accident committing your secrets un-encrypted.

After pre-commit is installed on your machine run:

```bash
pre-commit install-hooks
```

## Managing Secrets


## :handshake:&nbsp; Thanks
Big shout out to the following for the inspiration and manifests used in this
repo.

- Flux Managed Clusters:
    - [cbirkenbeul/k3s-gitops](https://github.com/cbirkenbeul/k3s-gitops)
    - [carpenike/k8s-gitops](https://github.com/carpenike/k8s-gitops)
    - [toboshii/home-cluster](https://github.com/toboshii/home-cluster)
- [k8s@home](https://github.com/k8s-at-home)
