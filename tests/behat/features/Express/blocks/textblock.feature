@textblock @block
Feature: Text Block Block
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete a text block block

@api
Scenario Outline: An authenticated user should be able to access the form for adding a text block block
  Given  I am logged in as a user with the <role> role
  When I go to "block/add/block"
  Then I should see <message>

    Examples:
    | role            | message             |
    | edit_my_content | "Access Denied"     |
    | content_editor  | "Create Basic page" |
    | site_owner      | "Create Basic page" |
    | administrator   | "Create Basic page" |
    | developer       | "Create Basic page" |

@api 
Scenario: An anonymous user should not be able to access the form for adding a text block block
  When I am on "block/add/block"
  Then I should see "Access denied"
  
@api @broken
Scenario Outline: An authenticated user should be able to create a text block block
  Given I am logged in as a user with the <role> role
  And I am on "block/add/block"
 And fill in "edit-label" with "New Text Block"
 And fill in "edit-title" with "Text Block Title"
 And I fill in "edit-field-block-text-und-0-value" with "An informative block of text about our program"
 And I press "Save"
 Then I should see "New Text Block"
 And I should see "An informative block of text about our program"
      
 Examples:
    | role            | 
    | content_editor  | 
    | site_owner      | 
    | administrator   | 
    | developer       | 
    
