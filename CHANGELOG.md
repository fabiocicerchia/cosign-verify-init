# Changelog

All notable changes to this project are documented here. The format is based
on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.0.0 (2026-07-29)


### Features

* add install.sh one-liner installer ([64bae14](https://github.com/fabiocicerchia/cosign-verify-init/commit/64bae140a7cf1edf25e3a5e097fe50ac415b63c5))


### Bug Fixes

* bump curl to 8.21.0-r0 for alpine 3.24 ([ee5bb03](https://github.com/fabiocicerchia/cosign-verify-init/commit/ee5bb032f8b02e473a1d9a137a6234c2b27cdeab))

## [Unreleased]

## [0.1.0]

### Added

- Init container that verifies cosign image signatures before the main workload starts.
- Key-based verification via mounted public key or inline PEM.
- Keyless (OIDC) verification with `CERT_IDENTITY` and `CERT_OIDC_ISSUER` support.
- `INSECURE_SKIP_TLOG` flag for air-gapped registries.
- Multi-arch image (`linux/amd64`, `linux/arm64`) published to GHCR.
- Example Kubernetes deployment manifest in `manifests/`.

[Unreleased]: https://github.com/fabiocicerchia/cosign-verify-init/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/fabiocicerchia/cosign-verify-init/releases/tag/v0.1.0
