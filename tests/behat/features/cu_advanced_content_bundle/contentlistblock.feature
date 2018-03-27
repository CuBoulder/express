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
