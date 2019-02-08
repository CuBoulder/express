@AdvancedDesign
Feature: A Sticky Menu keeps the main navigation on the screen
In order to make it easier for user to navigate on extra-long pages
As a user with the proper role
I should be able to enable the Sticky Menu feature

Scenario: An authenticated user can enable Sticky Menu
Given I am logged in as a user with the "site_owner" role
 And I am on "admin/structure/menu/settings"
 And I select "1" from "use_sticky_menu"
 And I press "Save configuration"
 And I go to "/"
Then the response should contain "id=\"sticky-menu\""
