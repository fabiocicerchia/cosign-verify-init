# Architecture

cosign-verify-init is a minimal init container that:

1. Reads `VERIFY_IMAGES` (space-separated image refs).
1. For each image, calls `cosign verify` with the configured key or OIDC params.
1. Exits `0` on success — Kubernetes starts the main container.
1. Exits non-zero on failure — the pod stays in `Init:Error`, main container never starts.

This gives per-workload supply-chain enforcement without a cluster-wide admission controller.
