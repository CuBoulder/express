  @social_media
  Feature: Twitter Feed Access Feature
  Test access to creation of content, configuration of settings, and viewing of content.

 Scenario Outline: Certain user roles should be able to create Create Twitter Block block content.
  Given  I am logged in as a user with the <role> role
  And I am on "block/add/twitter-block"
  Then I should see <message>

  Examples:
  | role            | message                       |
  | site_editor     | "Create Twitter Block block"  |
  | site_owner      | "Create Twitter Block block"  |
  | administrator   | "Create Twitter Block block"  |
  | developer       | "Create Twitter Block block"  |
  | edit_my_content | "Access Denied"                   |
  | edit_only       | "Access Denied"                   |

  Scenario: An anonymous user shouldn't be able to create Twitter Block block content.
  Given I am on "block/add/twitter-block"
  Then I should see "Access Denied"
