@AdvContentBundle 
Feature: the Content List block
In order to create a block with a list of nodes
As an authenticated user
I should be able to access and use the Content List Block
  
@api 
Scenario Outline: An authenticated user should be able to access the form for adding a content list block
  Given  I am logged in as a user with the <role> role
  When I go to "block/add/content-list"
  Then I should see <message>

  Examples:
  | role            | message         |
  | edit_my_content | "Access denied" |
  | content_editor  | "Create Content List block" |
  | site_owner      | "Create Content List block" |
  | administrator   | "Create Content List block" |
  | developer       | "Create Content List block" |
  
@api 
Scenario: An anonymous user should not be able to access the form
  Given I go to "block/add/content-list"
  Then I should see "Access denied"

@api 
Scenario Outline: An authenticated user should see a number of Sort options
Given I am logged in as a user with the "site_owner" role
And am on "block/add/content-list"
When I select <condition> from "edit-field-content-list-sort-und"

  Examples:
    | condition |
    | "_none" |
    | "Custom" |
    | "Date Created" |
    | "Date Created Reverse" |
    | "Alphabetical" |
    
 @api 
Scenario Outline: An authenticated user should see a number of Display options
Given I am logged in as a user with the "site_owner" role
And am on "block/add/content-list"
When I select <condition> from "edit-field-content-list-display-und"

  Examples:
    | condition |
    | "Teaser" |
    | "Embed" |
    | "Title" |
    | "Sidebar" |
    
@api @javascript
Scenario: A simple Content List block can be created
Given I am logged in as a user with the "site_owner" role
#CREATE A BASIC PAGE TO LOAD INTO THE LIST
And I am on "node/add/page"
And fill in "edit-title" with "Ducks"
And I follow "Disable rich-text"
And I fill in "Body" with "Ducks can fly and swim"
When I uncheck "edit-menu-enabled"
And I press "edit-submit"
Then I should see "Ducks"
And I go to "block/add/content-list"
And I fill in "edit-label" with "My Block Row Block Label"
And I fill in "edit-title" with "My Block Row Block Title"
And I fill in "edit-field-content-list-reference-und-0-target-id" with "Ducks"
And I wait 5 seconds
And I press "edit-submit"
Then I should see "My Block Row Block Title"
And I should see "Ducks can fly and swim"

