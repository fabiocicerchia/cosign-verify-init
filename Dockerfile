# cosign-verify-init — init container verifying image signatures before the
# main workload starts. Admission-controller guarantees without the controller.
#
# cosign 3.x, and the major matters: 3.x writes signatures in the new bundle
# format, tagged `sha256-<digest>` rather than `sha256-<digest>.sig`. A 2.x
# verifier does not look there, so it reports `no signatures found` for a
# correctly signed image — indistinguishable, from the outside, from an
# unsigned one. This container is the thing that fails a workload closed, so it
# must not be the older half of that pair. It still verifies 2.x signatures.
# VERSION-BUMP
ARG COSIGN_VERSION=3.1.3

FROM alpine:3.24@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS fetch
ARG COSIGN_VERSION
ARG TARGETARCH=amd64
# ponytail: apk versions pinned for scanners; bump when alpine 3.24 patches them
RUN apk add --no-cache curl=8.22.0-r0 ca-certificates=20260611-r0
RUN curl -fsSLo /cosign \
      "https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-${TARGETARCH}" \
 && chmod 0755 /cosign

FROM alpine:3.24@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b
ARG COSIGN_VERSION
LABEL org.opencontainers.image.title="cosign-verify-init" \
      org.opencontainers.image.description="Init container verifying image signatures before the workload starts" \
      org.opencontainers.image.version="${COSIGN_VERSION}" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.source="https://github.com/fabiocicerchia/cosign-verify-init"
RUN apk add --no-cache ca-certificates=20260611-r0 \
 && adduser -D -u 10001 verify
COPY NOTICE /NOTICE
COPY --from=fetch /cosign /usr/local/bin/cosign
COPY verify-images /usr/local/bin/verify-images
USER 10001
# One-shot verifier: it runs to completion, so there is nothing to health-check.
HEALTHCHECK NONE
ENTRYPOINT ["/usr/local/bin/verify-images"]
