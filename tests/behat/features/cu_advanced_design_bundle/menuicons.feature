@AdvancedDesign
Feature: Font Awesome Icons in menus
In order to add visual interest to my site
As a user with the proper role
I should be able to add icons to menu links

Scenario: An authenticated user can add an icon to the main menu
Given I am logged in as a user with the "site_owner" role
And I am on "admin/structure/menu/manage/main-menu"
And I fill in "edit-additem-title" with "Education"
And I press "edit-submit" 
Then the "edit-link-title" field should contain "Education"
And I fill in "edit-link-path" with "https://www.colorado.edu/education"
And I select "fa-bug" from "icon"
And I press "Save"
And I go to "/"
Then the response should contain "class=\"fa fa-fw fa-bug\""
