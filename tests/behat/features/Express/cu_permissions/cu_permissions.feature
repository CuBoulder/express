@roletest
Feature: CU Permissions


@api @cu_permissions
Scenario Outline: Some roles can create Block Designer themes
Given I am logged in as a user with the <role> role
When I go to "admin/theme/block-designer/add"
Then I should see <message>

Examples:
| role              | message   |
| developer          | "A name describing your block theme" |
| administrator       | "A name describing your block theme" |
| site_owner          | "A name describing your block theme" |
| content_editor      | "A name describing your block theme" |
| edit_my_content     | "Access Denied" |
| site_editor         | "A name describing your block theme" |
| edit_only           | "Access Denied" |

  @api @cu_permissions
  Scenario Outline: An site owner/administrator/content editor user should not be able to access certain admin settings
    Given  I am logged in as a user with the <role> role
    When I go to "admin/index"
    Then I should not see "<message>"
    And I should not see "<message1>"

    Examples:
      | role           |   message     | message1                |
      | site_owner     | jQuery Update | Express Layout Settings |
      | administrator  | jQuery Update | Express Layout Settings |
      | content_editor | jQuery Update | Express Layout Settings |


  @api @cu_permissions
  Scenario: A developer should be able to access certain admin settings
    Given  I am logged in as a user with the "developer" role
    When I go to "admin/index"
    Then I should see "jQuery Update"
    Then I should see "Express Layout Settings"
