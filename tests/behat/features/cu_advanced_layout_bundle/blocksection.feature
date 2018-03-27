@AdvLayouttBundle @block-section-block
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
