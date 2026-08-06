# Changelog

All notable changes to this project are documented here. The format is based
on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2](https://github.com/fabiocicerchia/cosign-verify-init/compare/v0.1.1...v0.1.2) (2026-08-06)


### Bug Fixes

* publish the image from the release job so it actually runs ([6438c50](https://github.com/fabiocicerchia/cosign-verify-init/commit/6438c5020300dfc0c353803ad84386822b00b2df))

## [0.1.1](https://github.com/fabiocicerchia/cosign-verify-init/compare/v0.1.0...v0.1.1) (2026-08-06)


### Bug Fixes

* **pre-commit:** stop check-yaml failing on Helm templates and multi-doc manifests ([b36c1c0](https://github.com/fabiocicerchia/cosign-verify-init/commit/b36c1c0b5116caa8ff3daaddda54c0360c6eafbf))
* **security:** skip the SARIF upload on private repos ([4058715](https://github.com/fabiocicerchia/cosign-verify-init/commit/4058715473dcba70e75e53c7238e7ac3675b6e27))

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
