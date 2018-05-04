Feature: CU Permissions

  @cu_permissions
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


  @cu_permissions
  Scenario: A developer should be able to access certain admin settings
    Given  I am logged in as a user with the "developer" role
    When I go to "admin/index"
    Then I should see "jQuery Update"
    Then I should see "Express Layout Settings"
    
 @cu_permissions @roletest
Feature: CU Permissions

Scenario Outline: All roles can access Admin Content
Given I am logged in as a user with the <role> role
When I go to "admin/content"
Then I should not see "Access denied"

Examples:
| role             | 
| developer        | 
| administrator    |
| site_owner       |
| content_editor   | 
| edit_my_content  | 
| site_editor      |
| edit_only        | 

Scenario Outline: All roles except EditMyContent can acccess Admin Content Blocks
Given I am logged in as a user with the <role> role
When I go to "admin/content/blocks"
Then I should see <message>

Examples:
| role             | message  |
| developer        | "Blocks" |
| administrator    | "Blocks" |
| site_owner       | "Blocks" |
| content_editor   | "Blocks" |
| edit_my_content  | "Access denied" |
| site_editor      | "Blocks" |
| edit_only        | "Blocks" |


Scenario Outline: All roles can acccess the Dashboard
Given I am logged in as a user with the <role> role
When I go to "admin/dashboard"
Then I should not see "Access denied"

Examples:
| role             | 
| developer        | 
| administrator    |
| site_owner       |
| content_editor   | 
| edit_my_content  | 
| site_editor      |
| edit_only        | 

@api 
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
| edit_my_content     | "Access denied" |
| site_editor         | "A name describing your block theme" |
| edit_only           | "Access denied" |

  
