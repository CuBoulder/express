@AdvContentBundle 
Feature: the Content Grid block
In order to create interesting layouts of graphics and text
As an authenticated user
I should be able to access and use the Content Grid Block
  
@api 
Scenario Outline: An authenticated user should be able to access the form for adding a content list block
  Given  I am logged in as a user with the <role> role
  When I go to "block/add/feature-callout"
  Then I should see <message>

  Examples:
  | role            | message         |
  | edit_my_content | "Access denied" |
  | content_editor  | "Create Content Grid block" |
  | site_owner      | "Create Content Grid block" |
  | administrator   | "Create Content Grid block" |
  | developer       | "Create Content Grid block" |
  
@api 
Scenario: An anonymous user should not be able to access the form
  Given I go to "block/add/feature-callout"
  Then I should see "Access denied
