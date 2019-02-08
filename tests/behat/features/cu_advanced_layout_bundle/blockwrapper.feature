@AdvLayoutBundle @block-wrapper-block
Feature: the Block Wrapper Block
In order to place system blocks as beans
As a user with the proper role
I should be able to access and use the Block Wrapper Block
  

Scenario Outline: An authenticated user should be able to access the form for adding a block wrapper block
    Given I am logged in as a user with the <role> role
    When I go to "block/add/block-wrapper"
    Then I should see <message>

    Examples:
    | role            | message         |
    | edit_my_content | "Access denied" |
    | edit_only       | "Access denied" |
    | content_editor  | "Create Block Wrapper block" |
    | site_owner      | "Create Block Wrapper block" |
    | administrator   | "Create Block Wrapper block" |
    | developer       | "Create Block Wrapper block" |


Scenario: An anonymous user should not be able to access the form
  Given I go to "block/add/block-wrapper"
  Then I should see "Access denied"

Scenario: A block wrapper block can be created
Given I am logged in as a user with the "site_owner" role
And I go to "block/add/block-wrapper"
And I fill in "edit-label" with "My Block Wrapper"
And I select "Footer Menu" from "edit-field-block-wrapper-reference-und"
And I press "Save"
Then I should see "Block Wrapper My Block Wrapper has been created."

Scenario: An EditOnly can edit a Block Wrapper Block
Given I am logged in as a user with the "edit_only" role
And am on "block/my-block-wrapper/view"
Then I should see the link "Edit Block"
And I follow "Edit Block"
Then I should see "Edit Block Wrapper: My Block Wrapper"
Then I should not see "Delete"
