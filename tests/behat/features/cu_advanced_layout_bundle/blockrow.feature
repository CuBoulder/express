@AdvLayoutBundle
Feature: the Block Row Block
In order to placed blocks side by side
As a user with the proper role
I should be able to access and use the Block Row Block
  
 @block-row-block
Scenario Outline: An authenticated user should be able to access the form for adding a block row block
    Given I am logged in as a user with the <role> role
    When I go to "block/add/block-row"
    Then I should see <message>

    Examples:
    | role            | message         |
    | edit_my_content | "Access denied" |
    | edit_only       | "Access denied" |
    | content_editor  | "Create Block Row block" |
    | site_owner      | "Create Block Row block" |
    | administrator   | "Create Block Row block" |
    | developer       | "Create Block Row block" |

 @block-row-block
Scenario: An anonymous user should not be able to access the form
  Given I go to "block/add/block-row"
  Then I should see "Access denied"

 @block-row-block @javascript
Scenario: A block row block can be created
  Given I am logged in as a user with the "site_owner" role

  # CREATE A TEXT BLOCK
  And I am on "block/add/block"
  And fill in "edit-label" with "BRText"
  And fill in "edit-title" with "BRText"
  And I press "edit-submit"
  Then I should see "Text Block BRText has been created."

  #CREATE BLOCK ROW BLOCK
  Then I go to "block/add/block-row"
  And I fill in "edit-label" with "Simple BR Block Label"
  And I fill in "edit-title" with "Simple BR Block Title"
  And I press "Add existing block"
  And I fill in "edit-field-block-row-collection-und-0-field-block-row-block-und-form-entity-id" with "BRText"
  And I check "edit-field-block-row-match-height-und"
  And I press "Save"
  Then I should see "Simple BR Block Title"
 
  @block-row-block
Scenario: An EditOnly can edit a Block Row Block
Given I am logged in as a user with the "edit_only" role
And am on "block/simple-br-block-label/view"
Then I should see the link "Edit Block"
And I follow "Edit Block"
Then I should see "Edit Block Row: Simple BR Block Label"
And I should not see "Delete"
