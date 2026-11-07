@domain:container-packaging @area:cosign-bundling @from:cosign-verify-init/dockerfile
Feature: Bundling cosign for signature checks
  Ships a cosign 3.x binary inside the image so operators can verify both new bundle-format and older signatures without installing anything.

  Background:
    Given the cosign-verify-init image was built for the operator's node architecture

  @id:container-packaging.cosign-bundling.001 @rule:packaging.cosign.verifies-bundle-format-signatures @inferred @source:Dockerfile#COSIGN_VERSION
  Scenario: An image signed with cosign 3.x is not mistaken for an unsigned one
    Given a workload image was signed with cosign 3.x in the bundle format
    And the operator supplies the matching public key
    When the init container verifies the workload image
    Then the bundled cosign finds the bundle-format signature
    And the verifier reports the image as OK
    And the workload is allowed to start

  @id:container-packaging.cosign-bundling.002 @rule:packaging.cosign.matches-target-architecture @inferred @source:Dockerfile#fetch
  Scenario Outline: The bundled cosign matches the architecture the image was built for
    When the operator runs the image built for <arch>
    Then the bundled cosign is the linux-<arch> release of the pinned version
    And cosign runs on the node without an exec format error

    Examples:
      | arch  |
      | amd64 |
      | arm64 |
