#!/bin/sh
set -eu
ROOT="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
cat > "$TMP/cosign" <<'STUB'
#!/bin/sh
while [ "$#" -gt 0 ] && [ "$1" != -- ]; do shift; done
printf '%s\n' "$*" >> "$CALLS"
STUB
chmod +x "$TMP/cosign"
export PATH="$TMP:$PATH" CALLS="$TMP/calls"
export KEYLESS=true CERT_IDENTITY=example CERT_OIDC_ISSUER=https://issuer.example
DIGEST=0000000000000000000000000000000000000000000000000000000000000000
UPPER=ABCDEF0000000000000000000000000000000000000000000000000000000000
for INVALID in 'example/app:latest' 'example/app@sha256:abc' "example/app@sha256:${DIGEST}0" \
  "example/app@sha256:${DIGEST%0}g" "example/app@sha256:$UPPER" "@sha256:$DIGEST" \
  "example/app@sha512:$DIGEST$DIGEST" "example/app@sha256:$DIGEST example/app:latest"; do
  if VERIFY_IMAGES="$INVALID" sh "$ROOT/verify-images" >/dev/null 2>&1; then
    echo "FAIL: invalid reference passed: $INVALID" >&2
    exit 1
  fi
done
[ ! -e "$CALLS" ]
VERIFY_IMAGES="example/app@sha256:$DIGEST example/app:1.0@sha256:$DIGEST" sh "$ROOT/verify-images" >/dev/null
grep -qx -- "-- example/app@sha256:$DIGEST" "$CALLS"
grep -qx -- "-- example/app:1.0@sha256:$DIGEST" "$CALLS"
# A flag-shaped reference must reach cosign as an operand, not an option.
VERIFY_IMAGES="--key=/dev/null@sha256:$DIGEST" sh "$ROOT/verify-images" >/dev/null
grep -qx -- "-- --key=/dev/null@sha256:$DIGEST" "$CALLS"
echo 'PASS: immutable-reference validation'
