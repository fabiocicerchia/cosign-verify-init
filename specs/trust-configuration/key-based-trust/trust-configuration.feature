@domain:trust-configuration @area:key-based-trust @from:cosign-verify-init/verify-images
Feature: Choosing what signatures to trust
  Operators choose whether images are trusted by a public key or by a keyless signer identity, and the gate refuses to run with an incomplete trust setup.

  Background:
    Given the images to verify are pinned by digest

  @id:trust-configuration.key-based-trust.001 @rule:trust.key.source-precedence @inferred @source:verify-images#COSIGN_PUBLIC_KEY
  Scenario Outline: An inline public key takes precedence over a mounted key file, which defaults to /keys/cosign.pub
    Given keyless verification is off
    And <inline key> is supplied inline
    And the key file path is <key path setting>
    When the init container starts
    Then signatures are checked against <key used>

    Examples:
      | inline key       | key path setting      | key used              |
      | a PEM public key | not set               | the inline key        |
      | a PEM public key | /etc/trust/cosign.pub | the inline key        |
      | no key           | /etc/trust/cosign.pub | /etc/trust/cosign.pub |
      | no key           | not set               | /keys/cosign.pub      |

  @id:trust-configuration.key-based-trust.002 @rule:trust.key.missing-refused @inferred @source:verify-images#COSIGN_KEY_PATH
  Scenario: Key-based verification without a readable key is refused
    Given keyless verification is off
    And no inline key is supplied
    And the key file path is not set
    And no readable key exists at /keys/cosign.pub
    When the init container starts
    Then standard error says "cosign-verify-init: no public key at /keys/cosign.pub"
    And it exits with status 64
    And no image is checked

  @id:trust-configuration.key-based-trust.003 @rule:trust.keyless.identity-and-issuer-required @inferred @source:verify-images#KEYLESS
  Scenario Outline: Keyless verification needs both a signer identity and an OIDC issuer
    Given keyless verification is on
    And the signer identity is <identity>
    And the OIDC issuer is <issuer>
    When the init container starts
    Then it exits with a non-zero status
    And standard error says "<message>"
    And no image is checked

    Examples:
      | identity                                                                 | issuer                                      | message                                               |
      | not set                                                                  | https://token.actions.githubusercontent.com | CERT_IDENTITY is required for keyless verification    |
      | https://github.com/example/app/.github/workflows/release.yml@refs/tags/* | not set                                     | CERT_OIDC_ISSUER is required for keyless verification |

  @id:trust-configuration.key-based-trust.004 @rule:trust.tlog.skip-opt-in @inferred @source:verify-images#INSECURE_SKIP_TLOG
  Scenario Outline: The transparency-log check is skipped only when the operator sets it to exactly true
    Given the skip transparency-log setting is <value>
    When the init container starts
    Then the transparency-log check is <outcome>

    Examples:
      | value   | outcome   |
      | true    | skipped   |
      | not set | performed |
      | yes     | performed |
      | TRUE    | performed |
