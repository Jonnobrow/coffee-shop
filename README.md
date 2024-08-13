> [!CAUTION]
> This is a work-in-progress. For the "stable" code see: https://github.com/Jonnobrow/coffee-shop/tree/main

<div align="center">

### Coffee Shop 2.0 ☕

_... managed with Flux and Renovate :robot:

</div>

## 📖 Overview

This is the repository for my home infrastructure and Kubernetes cluster. I follow infrastructure as Code (IaC) and GitOps practices using
tooling like [Terraform](https://www.terraform.io/), [Kubernetes](https://kubernetes.io/), [FluxCD](https://github.com/fluxcd/flux2), and
[Renovate](https://github.com/renovatebot/renovate).

## ☕ Why Coffee Shop?
- I like Coffee!
- *therefore* my servers and devices are coffee themed
    - Espresso: Proxmox VE Server
    - Cappuccino: NAS Virtual Machine (NFS+Samba Shares right now)
    - Mocha: Virtual Machine running K3s
    - Picolo: LXC Container running PiHole
    - Ristretto: Raspberry Pi 5 running Home Assistant

## :bricks:&nbsp; Infrastructure

**Currently the base infrastructure is manually provisioned :clown_face:**

## :technologist:&nbsp; Configuration

I use [Ansible](https://www.ansible.com/) roles for setting up infrastructure.

## ⛵ Kubernetes

### Installation

[k3s](https://k3s.io) provisioned on a PVE Virtual Machine running Ubuntu. I only have a single physical machine so currently only
run a single node - this may change as time goes on.

### Core Components
- [cert-manager](https://cert-manager.io/) - SSL certificates - with Cloudflare DNS challenge
- [flux](https://toolkit.fluxcd.io/) - GitOps tool for deploying manifests from the `cluster` directory
- [local-path-provisioner](https://github.com/rancher/local-path-provisioner) - default storage class provided by k3s
- [metallb](https://metallb.universe.tf/) - bare metal load balancer
- [traefik](https://traefik.io) - ingress controller

### GitOps

[FluxCD](https://github.com/fluxcd/flux2) watches the clusters in my [kubernetes](./kubernetes/) folder (see Directories below)
and makes the changes to my clusters based on the state of my Git repository.

Flux will recursively search the `kubernetes/${cluster}/apps` folder until it finds the most top level `kustomization.yaml` per directory and
then apply all the resources listed in it. That `kustomization.yaml` will generally only have a namespace resource and one or many Flux
kustomizations (`ks.yaml`). Under the control of those Flux kustomizations there will be a `HelmRelease` or other resources related to
the application which will be applied.

[Renovate](https://github.com/renovatebot/renovate) watches my **entire** repository looking for dependency updates, when they are found
a PR is automatically created. When some PRs are merged Flux applies the changes to my cluster.

### Directories

This Git repository contains the following directories under [Kubernetes](./kubernetes/).

```sh
📁 kubernetes
├── 📁 apps           # applications
├── 📁 bootstrap      # bootstrap procedures
└── 📁 cluster        # core flux configuration
```

### Repo Index

<!-- Begin apps section -->
<table>
  <tr>
    <th>Namespace</th>
    <th>Kind</th>
    <th>Name</th>
    <th>Supporting Services</th>
  </tr>
  <tr>
    <td></td>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/coffee-shop-2/apps/openebs/app/helmrelease.yaml">openebs</a></td>
    <td></td>
  </tr>
  <tr>
    <td>cert-manager</td>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/coffee-shop-2/apps/cert-manager/app/helmrelease.yaml">cert-manager</a></td>
    <td></td>
  </tr>
  <tr>
    <td>cnpg-system</td>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/coffee-shop-2/apps/cnpg/app/helmrelease.yaml">cnpg</a></td>
    <td></td>
  </tr>
  <tr>
    <td>external-dns</td>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/coffee-shop-2/apps/external-dns/cloudflare/helmrelease.yaml">external-dns-cloudflare</a></td>
    <td></td>
  </tr>
  <tr>
    <td>flux-system</td>
    <td><code>GitRepository</code></td>
    <td><a href="https://github.com/Jonnobrow/coffee-shop">coffee-shop-2</a></td>
    <td></td>
  </tr>
  <tr>
    <td>ingress-nginx</td>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/coffee-shop-2/apps/ingress-nginx/app/helmrelease.yaml">ingress-nginx</a></td>
    <td></td>
  </tr>
  <tr>
    <td>metallb-system</td>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/coffee-shop-2/apps/metallb/app/helmrelease.yaml">metallb</a></td>
    <td></td>
  </tr>
  <tr>
    <td>paperless-ngx</td>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/coffee-shop-2/apps/paperless-ngx/app/helmrelease.yaml">paperless-ngx</a></td>
    <td><a href="kubernetes/coffee-shop-2/apps/paperless-ngx/borgmatic/helmrelease.yaml">borgmatic</a>, <a href="kubernetes/coffee-shop-2/apps/paperless-ngx/postgresql/postgresq.yaml">postgresql</a>, <a href="kubernetes/coffee-shop-2/apps/paperless-ngx/redis/helmrelease.yaml">redis</a></td>
  </tr>
  <tr>
    <td>reflector</td>
    <td><code>HelmRelease</code></td>
    <td><a href="kubernetes/coffee-shop-2/apps/reflector/app/helmrelease.yaml">reflector</a></td>
    <td></td>
  </tr>
</table>
<!-- End apps section -->

## :handshake:&nbsp; Thanks
Shout out to the following projects / people for the inspiration, support and manifests used in this repo.

- https://kubesearch.dev/ : A great tool for finding other inspiration
- [gabe565/home-ops](https://github.com/gabe565/home-ops)
- [gabe565/charts](https://github.com/gabe565/charts)
- [bjw-s/home-ops](https://github.com/bjw-s/home-ops)
- [onedr0p/home-ops](https://github.com/onedr0p/home-ops)
