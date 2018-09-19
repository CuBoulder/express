Feature: Facebook Like Button Access Feature
  Test access to creation of social link beans.

  @social_media @max_execution_time
  Scenario Outline: Certain user roles should be able to create Create Facebook Like Button block content.
    Given  I am logged in as a user with the <role> role
    And I am on "block/add/facebook-like-button"
    Then I should see <message>

    Examples:
      | role            | message                              |
      | content_editor  | "Create Facebook Like Button block"  |
      | site_owner      | "Create Facebook Like Button block"  |
      | administrator   | "Create Facebook Like Button block"  |
      | developer       | "Create Facebook Like Button block"  |
      | edit_my_content | "Access Denied"                      |

  @social_media
  Scenario: An anonymous user shouldn't be able to create Create Facebook Like Button block content.
    Given I am on "block/add/facebook-like-button"
    Then I should see "Access Denied"
