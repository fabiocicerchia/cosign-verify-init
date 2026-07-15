#!/usr/bin/env bash
set -euo pipefail
# One-line installer for cosign-verify-init
# Usage: curl -fsSL https://raw.githubusercontent.com/fabiocicerchia/cosign-verify-init/main/install.sh | bash

IMAGE="ghcr.io/fabiocicerchia/cosign-verify-init:latest"

echo "Pulling cosign-verify-init from GHCR..."
docker pull "$IMAGE"
echo ""
echo "cosign-verify-init ready. Use it as a Kubernetes init container."
echo "See https://github.com/fabiocicerchia/cosign-verify-init for usage."
