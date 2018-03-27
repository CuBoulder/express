@AdvContentBundle @expandable
Feature: the Expandable (Quicktabs) block
In order to create the look of tabbed content
As an authenticated user
I should be able to access and use the Expandable Block
  
@api 
Scenario Outline: An authenticated user should be able to access the form for adding an expandable block
  Given  I am logged in as a user with the <role> role
  When I go to "block/add/expandable"
  Then I should see <message>

  Examples:
  | role            | message         |
  | edit_my_content | "Access denied" |
  | content_editor  | "Create Expandable block" |
  | site_owner      | "Create Expandable block" |
  | administrator   | "Create Expandable block" |
  | developer       | "Create Expandable block" |
  
@api 
Scenario: An anonymous user should not be able to access the form
  Given I go to "block/add/expandable"
  Then I should see "Access denied"
