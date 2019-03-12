@settings
Feature: Enabling Bundles
In order to add functionality to a Web Express site
An authenticated user with the proper role
Should be able to access the Bundle List pages

#SOME ROLES CAN ENABLE BUNDLES

Scenario Outline: Only Devs, Admins, SOs and ConMgrs can Enable Bundles
Given I am logged in as a user with the <role> role
When I go to "admin/settings/bundles/list"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Bundles" |
| administrator    | "Bundles" |
| site_owner       | "Bundles" |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "Access denied" |
| edit_only        | "Access denied" |
| access_manager   | "Access denied" |
| configuration_manager | "Bundles" |


Scenario: The Bundle List page displays 2 tabs
  Given I am logged in as a user with the "site_owner" role
  And am on "admin/settings/bundles/list"
  Then I should see "Bundles"
  And I should see "Enabled"
  And I should see "Available"
    