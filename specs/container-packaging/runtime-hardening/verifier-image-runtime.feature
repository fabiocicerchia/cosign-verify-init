@domain:container-packaging @area:runtime-hardening @from:cosign-verify-init/dockerfile
Feature: Running the verifier image as an init container
  Lets operators drop the published image into a pod as a one-shot, unprivileged init container that runs the verifier and exits.

  Background:
    Given the operator has deployed the cosign-verify-init image as an init container

  @id:container-packaging.runtime-hardening.001 @rule:packaging.runtime.runs-verifier-on-start @inferred @source:Dockerfile#ENTRYPOINT
  Scenario: Starting the image runs the image verifier and nothing else
    When the init container starts with no command override
    Then the verify-images verifier runs as the container's process
    And the container exits with the verifier's exit code
    And no health check is reported for the container

  @id:container-packaging.runtime-hardening.002 @rule:packaging.runtime.runs-as-non-root @inferred @source:Dockerfile#USER
  Scenario: The verifier runs as an unprivileged user
    When the init container starts without a security context overriding the user
    Then the verifier runs as user id 10001
    And the verifier does not run as root
