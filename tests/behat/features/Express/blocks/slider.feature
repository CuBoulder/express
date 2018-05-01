@blocks
Feature: Slider Block
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete a slider block

# 1) TEST BLOCK ADD PRIVILEGES
# 2) TEST THAT A SIMPLE BLOCK CAN BE CREATED AND REVISED
# 3) TEST EDITING AND DELETING PRIVILEGES ON THE BLOCK JUST MADE
# 4) TEST THAT THE DELETE BUTTON ACTUALLY WORKS
# 5) TEST MORE COMPLEX BLOCK CREATION

# 1) TEST BLOCK ADD PRIVILEGES
Scenario Outline: Block Access: Some roles can add a Slider block
Given I am logged in as a user with the <role> role
When I go to "block/add/slider"
Then I should see <message>

Examples:
 | role                  | message                      |
 | developer             | "Create Slider block" |
| administrator         | "Create Slider block" |
| site_owner            | "Create Slider block" |
| content_editor        | "Create Slider block" |
| edit_my_content       | "Access Denied"              |
| site_editor           | "Create Slider block" |
| edit_only             | "Access Denied"              |
| access_manager        | "Access Denied"              |
| configuration_manager | "Access Denied"              |

 Scenario: Block Access: An anonymous user cannot add a Slider block
  When I am on "block/add/slider"
  Then I should see "Access denied"
  
