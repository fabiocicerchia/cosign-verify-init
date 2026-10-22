# Getting Started

## Prerequisites

- A Kubernetes cluster
- Images signed with [cosign](https://github.com/sigstore/cosign)

## Key-based verification

1. Create a secret from your cosign public key:

   ```sh
   kubectl create secret generic cosign-pub --from-file=cosign.pub=./cosign.pub
   ```

1. Pin the workload image and `VERIFY_IMAGES` to the same real `@sha256:` digest
   (64 lowercase hexadecimal characters). Mutable tags are rejected. An init
   container cannot enforce that the pod specification uses the same reference;
   enforce that relationship with admission policy or your deployment generator.
1. Add the init container to your deployment (see `examples/basic/`).

## Keyless (OIDC) verification

Set `KEYLESS=true` along with `CERT_IDENTITY` and `CERT_OIDC_ISSUER` — no key
material needed. Works with images signed via GitHub Actions OIDC.
