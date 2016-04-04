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
  Scenario Outline: Users should be able to view Facebook Like block content.
    Given I am logged in as a user with the <role> role
    When I create a "social_links" block with the label "Social Links Block"
    Then I should see <message>

    Examples:
      | role            | message               |
      | content_editor  | "Social Links Block"  |
      | site_owner      | "Social Links Block"  |
      | administrator   | "Social Links Block"  |
      | developer       | "Social Links Block"  |
      | edit_my_content | "Access Denied"       |

  @api @social_media
  Scenario: Anonymous users shouldn't be able to view Facebook Like block content.
    Given I am an anonymous user
    When I create a "social_links" block with the label "Social Links Block"
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
  Scenario Outline: Users should be able to view Facebook Like block content.
    Given I am logged in as a user with the <role> role
    When I create a "facebook_activity" block with the label "Facebook Activity Block"
    Then I should see <message>

    Examples:
      | role            | message                    |
      | content_editor  | "Facebook Activity Block"  |
      | site_owner      | "Facebook Activity Block"  |
      | administrator   | "Facebook Activity Block"  |
      | developer       | "Facebook Activity Block"  |
      | edit_my_content | "Access Denied"            |

  @api @social_media
  Scenario: Anonymous users shouldn't be able to view Facebook Like block content.
    Given I am an anonymous user
    When I create a "facebook_activity" block with the label "Facebook Activity Block"
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
  Scenario Outline: Users should be able to view Facebook Like block content.
    Given I am logged in as a user with the <role> role
    When I create a "facebook_like_button" block with the label "Facebook Like Block"
    Then I should see <message>

    Examples:
      | role            | message                |
      | content_editor  | "Facebook Like Block"  |
      | site_owner      | "Facebook Like Block"  |
      | administrator   | "Facebook Like Block"  |
      | developer       | "Facebook Like Block"  |
      | edit_my_content | "Access Denied"        |

  @api @social_media
  Scenario: Anonymous users shouldn't be able to view Facebook Like block content.
    Given I am an anonymous user
    When I create a "facebook_like_button" block with the label "Facebook Like Block"
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

  @api @social_media
  Scenario Outline: Users should be able to view Twitter Block block content.
    Given I am logged in as a user with the <role> role
    When I create a "twitter_block" block with the label "Twitter Block"
    Then I should see <message>

    Examples:
      | role            | message          |
      | content_editor  | "Twitter Block"  |
      | site_owner      | "Twitter Block"  |
      | administrator   | "Twitter Block"  |
      | developer       | "Twitter Block"  |
      | edit_my_content | "Access Denied"  |

  @api @social_media
  Scenario: Anonymous users shouldn't be able to view Twitter Block block content.
    Given I am an anonymous user
    When I create a "twitter_block" block with the label "Twitter Block"
    Then I should see "Access Denied"


