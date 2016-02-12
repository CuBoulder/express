Feature: Events Bundle Access Feature
  Test access to creation of content, configuration of settings, and viewing of content.

  @api @social_media
  Scenario Outline: Certain user roles should be able to create Create Social Links block content.
    Given I am logged in as a user with the <role> role
    And I am on "block/add/social-links"
    Then I should see <message>

    Examples:
      | role            | message                      |
      | content_editor  | "Create Social Links block"  |
      | site_owner      | "Create Social Links block"  |
      | administrator   | "Create Social Links block"  |
      | developer       | "Create Social Links block"  |
      | edit_my_content | "Access Denied"              |

  @api @social_media
  Scenario: An anonymous user shouldn't be able to create Create Social Links block content.
    Given I am on "block/add/social-links"
    Then I should see "Access Denied"

  @api @social_media
  Scenario Outline: Certain user roles should be able to create Create Facebook Activity block content.
    Given I am logged in as a user with the <role> role
    And I am on "block/add/facebook-activity"
    Then I should see <message>

    Examples:
      | role            | message                           |
      | content_editor  | "Create Facebook Activity block"  |
      | site_owner      | "Create Facebook Activity block"  |
      | administrator   | "Create Facebook Activity block"  |
      | developer       | "Create Facebook Activity block"  |
      | edit_my_content | "Access Denied"                   |

  @api @social_media
  Scenario: An anonymous user shouldn't be able to create Create Facebook Activity block content.
    Given I am on "block/add/facebook-activity"
    Then I should see "Access Denied"

  @api @social_media
  Scenario Outline: Certain user roles should be able to create Create Facebook Like Button block content.
    Given I am logged in as a user with the <role> role
    And I am on "block/add/facebook-like-button"
    Then I should see <message>

    Examples:
      | role            | message                              |
      | content_editor  | "Create Facebook Like Button block"  |
      | site_owner      | "Create Facebook Like Button block"  |
      | administrator   | "Create Facebook Like Button block"  |
      | developer       | "Create Facebook Like Button block"  |
      | edit_my_content | "Access Denied"                      |

  @api @social_media
  Scenario: An anonymous user shouldn't be able to create Create Facebook Like Button block content.
    Given I am on "block/add/facebook-like-button"
    Then I should see "Access Denied"

  @api @social_media
  Scenario Outline: Certain user roles should be able to create Create Twitter Block block content.
    Given I am logged in as a user with the <role> role
    And I am on "block/add/twitter-block"
    Then I should see <message>

    Examples:
      | role            | message                       |
      | content_editor  | "Create Twitter Block block"  |
      | site_owner      | "Create Twitter Block block"  |
      | administrator   | "Create Twitter Block block"  |
      | developer       | "Create Twitter Block block"  |
      | edit_my_content | "Access Denied"               |

  @api @social_media
  Scenario: An anonymous user shouldn't be able to create Create Twitter Block block content.
    Given I am on "block/add/twitter-block"
    Then I should see "Access Denied"
