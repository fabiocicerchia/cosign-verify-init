@domain:image-verification @area:fail-closed-gate @from:cosign-verify-init/verify-images
Feature: Blocking the workload until every image signature verifies
  Operators rely on the init container to fail the pod closed, so an unsigned or wrongly signed image never runs.

  Background:
    Given the init container runs before the workload in a pod
    And a trusted public key is available

  @id:image-verification.fail-closed-gate.001 @rule:images.verification.all-must-verify @inferred @source:verify-images#VERIFY_IMAGES
  Scenario: The workload is released only when every listed image verifies
    Given the images to verify are "registry.example.com/app@sha256:<64 hex> registry.example.com/sidecar@sha256:<64 hex>"
    And both images are signed by the trusted key
    When the init container starts
    Then standard output shows "cosign-verify-init: verifying <image>" then "cosign-verify-init: OK <image>" for each image in list order
    And standard output ends with "cosign-verify-init: all images verified"
    And it exits with status 0

  @id:image-verification.fail-closed-gate.002 @rule:images.verification.stop-at-first-failure @verified @source:verify-images#VERIFY_IMAGES @test:test.sh#Smoke test
  Scenario: The first image that fails verification fails the pod and the rest are not checked
    Given the images to verify are "registry.example.com/app@sha256:<64 hex> registry.example.com/sidecar@sha256:<64 hex>"
    And the first image is not signed by the trusted key
    When the init container starts
    Then standard error shows "cosign-verify-init: FAILED registry.example.com/app@sha256:<64 hex>" followed by cosign's own error output
    And the second image is never checked
    And it exits with status 1 and the workload does not start

  @id:image-verification.fail-closed-gate.003 @rule:images.references.operand-only @verified @source:verify-images#VERIFY_IMAGES @test:test-validation.sh#immutable-reference validation
  Scenario: An image reference that looks like an option is verified as an image, never obeyed as a setting
    Given the images to verify are "--key=/dev/null@sha256:<64 hex>"
    When the init container starts
    Then the reference is handed to cosign as the image to check, after the end-of-options marker
    And the operator's configured trust settings are not overridden

  @id:image-verification.fail-closed-gate.004 @rule:images.list.blank-list-passes @inferred @source:verify-images#VERIFY_IMAGES @questionable
  Scenario: An image list made only of spaces passes the gate without verifying anything
    Given the images to verify are "   " (spaces only)
    When the init container starts
    Then no image is checked
    And standard output shows "cosign-verify-init: all images verified"
    And it exits with status 0 and the workload starts
