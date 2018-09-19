@settings @menus
Feature: Configuring Menus
In order to adjust navigation on a Web Express site
An authenticated user with the proper role
Should be able to access the Menu Configuration pages

# TESTS FOR COMPLETE MENU FUNCTIONALITY ARE IN menus/menus.feature

Scenario Outline: Higher level roles get the link to Configure Menus
Given I am logged in as a user with the <role> role
When I gm on "admin/settings"
Then I should see the link "Configure Menus"

Examples:
| role           |
| developer      |
| administrator  |
| site_owner     |
| site_editor    |
| content_editor |

Scenario Outline: Lower level roles do not get the link to Configure Menus
Given I am logged in as a user with the <role> role
When I gm on "admin/settings"
Then I should not see "Configure Menus"

Examples:
| role                  |
| edit_my_content       |
| edit_only             |
