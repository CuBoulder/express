@slider @block
Feature: Hero Unit Block
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete a hero unit block

@api
Scenario Outline: An authenticated user should be able to access the form for adding a slider block
  Given  I am logged in as a user with the <role> role
  When I go to "block/add/hero-unit"
  Then I should see <message>

    Examples:
    | role            | message             |
    | edit_my_content | "Access Denied"     |
    | content_editor  | "Create Basic page" |
    | site_owner      | "Create Basic page" |
    | administrator   | "Create Basic page" |
    | developer       | "Create Basic page" |

@api 
Scenario: An anonymous user should not be able to access the form for adding a slider block
  When I am on "block/add/hero-unit"
  Then I should see "Access denied"

@api @broken
Scenario Outline: An authenticated user should be able to create a slider block
  Given I am logged in as a user with the <role> role
  And I am on "block/add/hero-unit"
 And fill in "edit-label" with "New Hero Unit"
 And fill in "edit-title" with "Hero Unit Title"
 And I fill in "edit-field-hero-unit-headline-und-0-value" with "Important Headline"
 And I fill in "edit-field-hero-unit-text-und-0-value" with "Learn more about our program"
 And I press "Save"
 Then I should see "Hero Unit Title"
 And I should see "Learn more about our program"
      
 Examples:
    | role            | 
    | content_editor  | 
    | site_owner      | 
    | administrator   | 
    | developer       | 
    
    
