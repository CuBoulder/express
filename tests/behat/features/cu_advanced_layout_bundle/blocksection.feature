@AdvLayoutBundle @block-section-block
Feature: the Block Section Block
In order to place a block on a background graphic
As an authenticated user
I should be able to access and use the Block Section Block
  
@api 
Scenario Outline: An authenticated user should be able to access the form for adding a block section block
    Given I am logged in as a user with the <role> role
    When I go to "block/add/block-section"
    Then I should see <message>

    Examples:
    | role            | message         |
    | edit_my_content | "Access denied" |
    | content_editor  | "Create Block Section block" |
    | site_owner      | "Create Block Section block" |
    | administrator   | "Create Block Section block" |
    | developer       | "Create Block Section block" |

@api 
Scenario: An anonymous user should not be able to access the form
  Given I go to "block/add/block-section"
  Then I should see "Access denied"


@api
Scenario: A block section block can be created
Given I am logged in as a user with the "site_owner" role
And I go to "block/add/block-section"
And I fill in "edit-label" with "My Block Section Block Label"
And I fill in "edit-title" with "My Block Section Block Title"

# CREATE a TEXT BLOCK
And I select "Text Block" from "edit-field-blocks-section-blocks-und-actions-bundle"
And I wait 5 seconds
And I fill in "edit-field-blocks-section-blocks-und-form-label" with "Ralphie Buffalo Label"
And I fill in "edit-field-blocks-section-blocks-und-form-title" with "Ralphie Buffalo Title"
 And fill in "Body" with "Ralphie Handlers run Ralphie around Folsom Field."
 And I press "Create block"
And I attach the file "ralphie.jpg" to "edit-field-block-section-bg-image-und-0-upload"
And I press "edit-field-block-section-bg-image-und-0-upload-button"
And I press "Save"
Then I should see "My Block Section Block Title"
And I should see "Ralphie Buffalo Title"
And I should see "Ralphie Handlers run Ralphie around Folsom Field."
