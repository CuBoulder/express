  @social_media
  Feature: Facebook Activity Access Feature
  Test access to creation of social link beans.

  Scenario Outline: Certain user roles should be able to create Create Facebook Activity block content.
  Given  I am logged in as a user with the <role> role
  And I am on "block/add/facebook-activity"
  Then I should see <message>

  Examples:
  | role            | message                           |
  | site_editor     | "Create Facebook Activity block"  |
  | site_owner      | "Create Facebook Activity block"  |
  | administrator   | "Create Facebook Activity block"  |
  | developer       | "Create Facebook Activity block"  |
  | edit_my_content | "Access Denied"                   |
  | edit_only       | "Access Denied"                   |

  Scenario: An anonymous user shouldn't be able to create Facebook Activity block content.
  Given I am on "block/add/facebook-activity"
  Then I should see "Access Denied"
