@AdvContentBundle @expandable
Feature: the Content List page
In order to create a node with a list of other nodes
As an authenticated user
I should be able to access and use the Content List page
  
@api 
Scenario Outline: An authenticated user should be able to access the content list page
  Given  I am logged in as a user with the <role> role
  When I go to "node/add/content-list-page"
  Then I should see <message>

  Examples:
  | role            | message         |
  | edit_my_content | "Access denied" |
  | content_editor  | "Create Content List Page" |
  | site_owner      | "Create Content List Page" |
  | administrator   | "Create Content List Page" |
  | developer       | "Create Content List Page" |
  
@api 
Scenario: An anonymous user should not be able to access the form
  Given I go to "node/add/content-list-page"
  Then I should see "Access denied"
