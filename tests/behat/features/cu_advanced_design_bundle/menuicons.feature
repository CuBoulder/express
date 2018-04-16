@AdvDesign @abcdefg
Feature: Font Awesome Icons in menus and block titles
In order to add visual interest to my site
As an authenticated user
I should be able to add icons to menus and block titles

Scenario: An authenticated user can add an icon to the main menu
Given I am logged in as a user with the "site_owner" role
And I am on "admin/structure/menu/manage/main-menu"
And I fill in "edit-additem-title" with "Academics"
And I press "edit-submit" 
Then the "edit-link-title" field should contain "Academics"
And I fill in "edit-link-path" with "https://www.colorado.edu/academics"
And I select "fa-bug" from "icon"
And I press "Save"
And I go to "/"
Then the response should contain "class=\"fa fa-fw fa-bug\""

