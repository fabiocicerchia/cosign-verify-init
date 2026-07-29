# cosign-verify-init

[![CI](https://github.com/fabiocicerchia/cosign-verify-init/actions/workflows/ci.yml/badge.svg)](https://github.com/fabiocicerchia/cosign-verify-init/actions/workflows/ci.yml)
[![Security](https://github.com/fabiocicerchia/cosign-verify-init/actions/workflows/security.yml/badge.svg)](https://github.com/fabiocicerchia/cosign-verify-init/actions/workflows/security.yml)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/fabiocicerchia/cosign-verify-init/badge)](https://securityscorecards.dev/viewer/?uri=github.com/fabiocicerchia/cosign-verify-init)
[![Release](https://img.shields.io/github/v/release/fabiocicerchia/cosign-verify-init)](https://github.com/fabiocicerchia/cosign-verify-init/releases)

An **init container that verifies image signatures with cosign before the
main workload starts**. If the signature doesn't verify, the pod never runs.
Supply-chain enforcement without installing an admission controller —
per-workload, incrementally adoptable.

## Install

```sh
docker pull ghcr.io/fabiocicerchia/cosign-verify-init:latest
```

Or use the install script:

```sh
curl -fsSL https://raw.githubusercontent.com/fabiocicerchia/cosign-verify-init/main/install.sh | bash
```

## Usage

```yaml
initContainers:
  - name: verify
    image: fabiocicerchia/cosign-verify-init
    env:
      - { name: VERIFY_IMAGES, value: "registry.example.com/my-app:1.4.2" }
    volumeMounts:
      - { name: cosign-pub, mountPath: /keys, readOnly: true }
```

See [`manifests/example-deployment.yaml`](manifests/example-deployment.yaml).

Keyless (GitHub Actions OIDC) verification:

```yaml
env:
  - name: VERIFY_IMAGES
    value: "ghcr.io/org/app:1.2.3"
  - name: KEYLESS
    value: "true"
  - name: CERT_IDENTITY
    value: "https://github.com/org/app/.github/workflows/release.yml@.*"
  - name: CERT_OIDC_ISSUER
    value: "https://token.actions.githubusercontent.com"
```

## Configuration

| Variable | Purpose |
|---|---|
| `VERIFY_IMAGES` | space-separated image refs to verify (required) |
| `COSIGN_KEY_PATH` | mounted public key (default `/keys/cosign.pub`) |
| `COSIGN_PUBLIC_KEY` | inline PEM alternative |
| `KEYLESS` + `CERT_IDENTITY` + `CERT_OIDC_ISSUER` | keyless mode |
| `INSECURE_SKIP_TLOG` | skip Rekor check (air-gapped registries) |

## Honest caveat

An init container is a *speed bump*, not a boundary: it can't stop kubelet
from pulling the unverified image, and a compromised namespace admin can
remove it. For hard enforcement use a policy controller; use this where
installing one isn't an option or as defense-in-depth.

## Development

`make build` / `make lint` / `make test` (negative-path: unsigned image must
fail).

Releases are automated: merge [Conventional Commit](https://www.conventionalcommits.org/)
PRs into `main`, then merge the release-please PR to tag `vX.Y.Z` and push the
image to GHCR. See [CONTRIBUTING.md](CONTRIBUTING.md#releases).

## Support

Need help implementing this? [Get in touch](https://fabiocicerchia.it/contact).

## License

Apache 2.0 — see [LICENSE](LICENSE).
