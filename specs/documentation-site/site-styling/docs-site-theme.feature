@domain:documentation-site @area:site-styling @from:docs/stylesheets
Feature: Branding the documentation site
  Gives readers of the cosign-verify-init documentation a consistent, self-contained supply-chain-security look in light and dark mode without fetching anything from third parties.

  Background:
    Given the documentation site is published with the project's custom theme

  @id:documentation-site.site-styling.002 @rule:documentation-site.site-styling.no-third-party-requests @inferred @source:docs/stylesheets/extra.css#:root
  Scenario: The documentation theme loads nothing from external servers
    Given the reader's browser cannot reach any third-party host
    When a reader opens a documentation page
    Then body text renders in the operating system's own sans-serif font
    And code renders in the operating system's own monospace font
    And no web font, CDN asset or analytics request is made by the theme
