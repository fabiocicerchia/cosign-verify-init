@domain:documentation-site @area:site-styling @from:docs/stylesheets
Feature: Branding the documentation site
  Gives readers of the cosign-verify-init documentation a consistent, self-contained supply-chain-security look in light and dark mode without fetching anything from third parties.

  Background:
    Given the documentation site is published with the project's custom theme

  @id:documentation-site.site-styling.001 @rule:documentation-site.site-styling.security-accent-palette @inferred @source:docs/stylesheets/extra.css#:root @questionable
  Scenario Outline: The docs and the splash page share the security orange-red accent pair
    Given the reader's colour scheme is <scheme>
    When a reader opens a documentation page
    Then links are shown in <link_colour>
    And primary buttons and the home page title use an orange-to-red gradient from #fb923c to #ef4444
    And the splash page uses the same accent pair as the rendered docs

    Examples:
      | scheme | link_colour |
      | light  | #ef4444     |
      | dark   | #fb923c     |

  @id:documentation-site.site-styling.002 @rule:documentation-site.site-styling.no-third-party-requests @inferred @source:docs/stylesheets/extra.css#:root
  Scenario: The documentation theme loads nothing from external servers
    Given the reader's browser cannot reach any third-party host
    When a reader opens a documentation page
    Then body text renders in the operating system's own sans-serif font
    And code renders in the operating system's own monospace font
    And no web font, CDN asset or analytics request is made by the theme

  @id:documentation-site.site-styling.003 @rule:documentation-site.site-styling.dark-scheme-ground @inferred @source:docs/stylesheets/extra.css#[data-md-color-scheme="slate"]
  Scenario: Dark mode uses a near-black background across page, header and tabs
    Given the reader's colour scheme is dark
    When a reader opens a documentation page
    Then the page, header and navigation tabs share the background colour #0b0f1a
    And links remain readable in #fb923c

  @id:documentation-site.site-styling.004 @rule:documentation-site.site-styling.no-placeholder-logo @inferred @source:docs/stylesheets/extra.css#.md-header__button.md-logo @questionable
  Scenario: The site shows no placeholder logo while the project has none
    Given the site configuration sets no project logo
    When a reader opens a documentation page
    Then no logo appears in the header
    And no logo appears in the navigation drawer title
