@domain:image-verification @area:digest-pinning @from:cosign-verify-init/verify-images
Feature: Accepting only pinned image references
  Operators get a guarantee that only immutable repository@sha256 images are ever checked, so a moved tag can never slip a different image past the gate.

  Background:
    Given the init container runs before the workload in a pod

  @id:image-verification.digest-pinning.001 @rule:images.list.required @inferred @source:verify-images#VERIFY_IMAGES
  Scenario: Verification refuses to start without an image list
    Given no images to verify are configured
    When the init container starts
    Then it exits with a non-zero status
    And standard error says "VERIFY_IMAGES is required (space-separated image refs)"
    And no image is verified and the workload does not start

  @id:image-verification.digest-pinning.002 @rule:images.references.pinned-digest-required @verified @source:verify-images#VERIFY_IMAGES @test:test-validation.sh#immutable-reference validation
  Scenario Outline: An image list with any mutable or malformed reference is refused before anything is verified
    Given the images to verify are "<images>"
    When the init container starts
    Then it exits with status 64
    And standard error says "<message>"
    And no image signature is checked, not even the valid ones in the list

    Examples:
      | images                                         | message                                                                             |
      | example/app:latest                             | mutable image reference refused: example/app:latest; use repository@sha256:<digest> |
      | example/app@sha512:<128 hex>                   | mutable image reference refused                                                     |
      | example/app@sha256:<64 hex> example/app:latest | mutable image reference refused: example/app:latest                                 |
      | example/app@sha256:ABCDEF<58 hex>              | invalid sha256 digest                                                               |
      | example/app@sha256:<63 hex>g                   | invalid sha256 digest                                                               |
      | example/app@sha256:                            | invalid sha256 digest                                                               |
      | example/app@sha256:abc                         | expected repository@sha256:<64 lowercase hex characters>                            |
      | example/app@sha256:<65 hex>                    | expected repository@sha256:<64 lowercase hex characters>                            |
      | @sha256:<64 hex>                               | expected repository@sha256:<64 lowercase hex characters>                            |

  @id:image-verification.digest-pinning.003 @rule:images.references.tag-plus-digest-accepted @verified @source:verify-images#VERIFY_IMAGES @test:test-validation.sh#immutable-reference validation
  Scenario: A reference carrying both a tag and a digest is accepted and verified as given
    Given the images to verify are "example/app@sha256:<64 hex> example/app:1.0@sha256:<64 hex>"
    And both images are signed by the trusted key
    When the init container starts
    Then each reference is checked exactly as written, tag included
    And it exits with status 0
