# cosign-verify-init — init container verifying image signatures before the
# main workload starts. Admission-controller guarantees without the controller.
ARG COSIGN_VERSION=2.5.3

FROM alpine:3.24 AS fetch
ARG COSIGN_VERSION
ARG TARGETARCH=amd64
# ponytail: apk versions pinned for scanners; bump when alpine 3.24 patches them
RUN apk add --no-cache curl=8.21.0-r0 ca-certificates=20260611-r0
RUN curl -fsSLo /cosign \
      "https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-${TARGETARCH}" \
 && chmod 0755 /cosign

FROM alpine:3.24
ARG COSIGN_VERSION
LABEL org.opencontainers.image.title="cosign-verify-init" \
      org.opencontainers.image.description="Init container verifying image signatures before the workload starts" \
      org.opencontainers.image.version="${COSIGN_VERSION}" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.source="https://github.com/fabiocicerchia/cosign-verify-init"
RUN apk add --no-cache ca-certificates=20260611-r0 \
 && adduser -D -u 10001 verify
COPY --from=fetch /cosign /usr/local/bin/cosign
COPY verify-images /usr/local/bin/verify-images
USER 10001
# One-shot verifier: it runs to completion, so there is nothing to health-check.
HEALTHCHECK NONE
ENTRYPOINT ["/usr/local/bin/verify-images"]
