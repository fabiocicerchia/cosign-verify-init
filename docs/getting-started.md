# Getting Started

## Prerequisites

- A Kubernetes cluster
- Images signed with [cosign](https://github.com/sigstore/cosign)

## Key-based verification

1. Create a secret from your cosign public key:
   ```sh
   kubectl create secret generic cosign-pub --from-file=cosign.pub=./cosign.pub
   ```

2. Add the init container to your deployment (see `examples/basic/`).

## Keyless (OIDC) verification

Set `KEYLESS=true` along with `CERT_IDENTITY` and `CERT_OIDC_ISSUER` — no key
material needed. Works with images signed via GitHub Actions OIDC.
