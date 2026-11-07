@domain:container-packaging @area:image-metadata @from:cosign-verify-init/dockerfile
Feature: Describing the published verifier image
  Gives registries, scanners and compliance tooling the title, licence, source and version of the published image.

  Background:
    Given the cosign-verify-init image has been published

  @id:container-packaging.image-metadata.001 @rule:packaging.metadata.oci-labels @inferred @source:Dockerfile#LABEL @questionable
  Scenario Outline: The published image carries OCI labels describing it
    When a registry or scanner reads the image's OCI labels
    Then label <label> is "<value>"

    Examples:
      | label                             | value                                                |
      | org.opencontainers.image.title    | cosign-verify-init                                   |
      | org.opencontainers.image.licenses | Apache-2.0                                           |
      | org.opencontainers.image.source   | https://github.com/fabiocicerchia/cosign-verify-init |
      | org.opencontainers.image.version  | 3.1.3                                                |

  @id:container-packaging.image-metadata.002 @rule:packaging.metadata.licence-notice-shipped @inferred @source:Dockerfile#COPY
  Scenario: The image ships the project's licence notice
    When an auditor inspects the image filesystem
    Then the project NOTICE file is present at /NOTICE
