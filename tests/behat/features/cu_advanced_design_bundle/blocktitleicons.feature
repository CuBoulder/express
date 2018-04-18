@AdvDesign
Feature: Font Awesome Icons in block titles
In order to add visual interest to my site
As an authenticated user
 I should be able to attach Font Awesome icons to my block titles

 @api 
Scenario: An authenticated user can add an icon to a block title
Given I am logged in as a user with the "site_owner" role
# CREATE A TEXT BLOCK
 And I am on "block/add/block"
 And I fill in "edit-label" with "ABC Text Block Label"
 And fill in "edit-title" with "ABC Text Block Title"
And I fill in "Body" with "A is for Apple"
 And I press "Save"
 # ATTACH AN ICON TO THE BLOCK
And I follow "Block Designer"
And I select "fa-apple" from "icon"
 And I press "edit-submit"
 Then I should see "Block Desiger settings have been saved."
 # CREATE BASIC PAGE
Then I go to "node/add/page"
  And fill in "edit-title" with "About Apples"
  And fill in "Body" with "Apple blossom is the state flower of Michigan."
  And I press "edit-submit"
Then I should see "About Apples"
# ADD BLOCK TO PAGE
And I follow "Edit Layout"
And I press "edit-field-sidebar-second-und-actions-ief-add-existing"
And I fill in "edit-field-sidebar-second-und-form-entity-id" with "ABC Text Block Title"
And I wait 5 seconds
And I press "Add block"
And I press "edit-submit"
Then I should see "ABC Text Block Title"
Then the response should contain "class=\"fa fa-apple\""
