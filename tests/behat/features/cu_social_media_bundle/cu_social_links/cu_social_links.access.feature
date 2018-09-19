Feature: Social Links Access Feature
  Test access to creation of social link beans.

  @social_media
  Scenario Outline: Certain user roles should be able to create Create Social Links block content.
  Given  I am logged in as a user with the <role> role
  And I am on "block/add/social-links"
  Then I should see <message>

  Examples:
  | role            | message                      |
  | content_editor  | "Create Social Links block"  |
  | site_owner      | "Create Social Links block"  |
  | administrator   | "Create Social Links block"  |
  | developer       | "Create Social Links block"  |
  | edit_my_content | "Access Denied"              |

  @social_media
  Scenario: An anonymous user shouldn't be able to create Create Social Links block content.
  Given I am on "block/add/social-links"
  Then I should see "Access Denied"
