#!/usr/bin/env sh
# Smoke test: cosign runs; an unsigned image with a random key must FAIL
# (negative path is the one that matters for a gate).
set -eu
IMAGE="${1:?usage: test.sh <image:tag>}"
docker run --rm --entrypoint cosign "$IMAGE" version >/dev/null
TMP="$(mktemp -d)"
docker run --rm --entrypoint sh "$IMAGE" -c \
  'cd /tmp && COSIGN_PASSWORD= cosign generate-key-pair >/dev/null 2>&1 && cat cosign.pub' > "$TMP/cosign.pub"
docker pull alpine:3.22 >/dev/null
UNSIGNED="$(docker inspect --format '{{index .RepoDigests 0}}' alpine:3.22)"
# Exit 1 is cosign's refusal; 64 is the reference check, which never runs cosign.
if docker run --rm -v "$TMP:/keys:ro" -e VERIFY_IMAGES="$UNSIGNED" "$IMAGE" 2>/dev/null; then RC=0; else RC=$?; fi
if [ "$RC" -ne 1 ]; then
  echo "FAIL: unsigned image exited $RC, want 1 from cosign" >&2; rm -rf "$TMP"; exit 1
fi
rm -rf "$TMP"
echo PASS
