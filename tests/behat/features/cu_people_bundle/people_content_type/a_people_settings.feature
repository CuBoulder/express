Feature: People Settings

  @api @people_settings
  Scenario Outline: An site owner/administrator/developer should be able to access the settings people page
  Given  I am logged in as a user with the <role> role
  When I go to "admin/settings/people/settings"
  Then I should not see <message>

  Examples:
  | role           | message         |
  | site_owner     | "Access denied" |
  | administrator  | "Access denied" |
  | developer      | "Access denied" |

  @api 
  Scenario: A site owner should see default settings for people labels
    Given  I am logged in as a user with the "site_owner" role
    And am on "admin/settings/people/settings"
    Then the "edit-type-label" field should contain "type"
