# Changelog

All notable changes to this project are documented here. The format is based
on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
