@AdvLayoutBundle @javascript
Feature: the Block Row Block
In order to placed blocks side by side
As an authenticated user
I should be able to access and use the Block Row Block
  
@api @block-row-block
Scenario Outline: An authenticated user should be able to access the form for adding a block row block
    Given I am logged in as a user with the <role> role
    When I go to "block/add/block-row"
    Then I should see <message>

    Examples:
    | role            | message         |
    | edit_my_content | "Access denied" |
    | content_editor  | "Create Block Row block" |
    | site_owner      | "Create Block Row block" |
    | administrator   | "Create Block Row block" |
    | developer       | "Create Block Row block" |

@api @block-row-block
Scenario: An anonymous user should not be able to access the form
  Given I go to "block/add/block-row"
  Then I should see "Access denied"

# CREATE TWO TEXT BLOCKS FOR BLOCK ROW CREATION TEST
#Scenario: Create two text blocks for block row heights test
#Given I am logged in as a user with the "site_owner" role
#And I go to "block/add/block"
#And fill in "edit-label" with "Sample Text One"
#And fill in "edit-title" with "Sample Text One"
#And I follow "Disable rich-text"
#And I fill in "Body" with "Cupcake ipsum dolor sit amet ice cream cake sweets carrot cake carrot cake. Tart candy pastry sweet roll candy tart sugar plum pudding."
#And I press "Save"
#And I go to "block/add/block"
#And fill in "edit-label" with "Sample Text Two"
#And fill in "edit-title" with "Sample Text Two"
#And I follow "Disable rich-text"
#And I fill in "Body" with "Lemon drops dessert chocolate gingerbread dessert"
#And I press "Save"
#And I go to "admin/content/blocks"
#Then I should see "Sample Text One"
#And I should see "Sample Text Two"

@api
Scenario: All blocks have the same height when "Match Heights" checkbox is checked
Given I am logged in as a user with the "site_owner" role
And I go to "block/add/block-row"
And I fill in "edit-label" with "My Block Row Block"
And I fill in "edit-title" with "My Block Row Block"

# CREATE FIRST TEXT BLOCK
And I select "Text Block" from "edit-field-block-row-collection-und-0-field-block-row-block-und-actions-bundle"
And I fill in "edit-field-block-row-collection-und-0-field-block-row-block-und-form-label" with "Text One Label"
And I fill in "edit-field-block-row-collection-und-0-field-block-row-block-und-form-title" with "Text One Title"
And I follow "Disable rich-text"
 And fill in "Body" with "Cupcake ipsum dolor sit amet ice cream carrot cake"
 And I press "Create block"

 # CREATE SECOND TEXT BLOCK
 And I press "Add another column"
And I select "Text Block" from "edit-field-block-row-collection-und-0-field-block-row-block-und-actions-bundle"
And I fill in "edit-field-block-row-collection-und-0-field-block-row-block-und-form-label" with "Text Two Label"
And I fill in "edit-field-block-row-collection-und-0-field-block-row-block-und-form-title" with "Text Two Title"
And I follow "Disable rich-text"
 And fill in "Body" with "Lemon drops dessert chocolate gingerbread dessert"
 And I press "Create block"

And I press "Save"
Then I should see "My Block Row Block"
Then I should see "Cupcake ipsum dolor sit amet ice cream carrot cake"
And I should see "Lemon drops dessert chocolate gingerbread dessert"
 
