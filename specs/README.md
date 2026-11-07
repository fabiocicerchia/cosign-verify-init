# Specifications of cosign-verify-init

What this code does, one atomic Gherkin scenario per behaviour, read from the code by code-atlas.
Tags: `@verified` a test asserts it · `@inferred` read from the code only · `@gap` an entry point no test covers · `@human` written or amended by a person, never rewritten.

## Container packaging
The minimal, hardened container image that ships the verifier as a Kubernetes init container.

- **Cosign bundling**: [Bundling cosign for signature checks](container-packaging/cosign-bundling/bundled-cosign.feature) (2)
- **Image metadata**: [Describing the published verifier image](container-packaging/image-metadata/verifier-image-metadata.feature) (2)
- **Runtime hardening**: [Running the verifier image as an init container](container-packaging/runtime-hardening/verifier-image-runtime.feature) (2)

## Documentation site
The published user documentation for the project.

- **Site styling**: [Branding the documentation site](documentation-site/site-styling/docs-site-theme.feature) (4)

## Image verification
Checking that every workload image carries a valid cosign signature before the pod is allowed to start.

- **Digest pinning**: [Accepting only pinned image references](image-verification/digest-pinning/pinned-image-references.feature) (3)
- **Fail-closed gate**: [Blocking the workload until every image signature verifies](image-verification/fail-closed-gate/signature-gate.feature) (4)

## Trust configuration
How operators tell the verifier which signers and trust sources to accept.

- **Key-based trust**: [Choosing what signatures to trust](trust-configuration/key-based-trust/trust-configuration.feature) (4)
