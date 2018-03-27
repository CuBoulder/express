@AdvLayouttBundle @block-section-block
Feature: the Block Section Block
In order to place a block on a background graphic
As an authenticated user
I should be able to access and use the Block Section
  
@api 
Scenario Outline: An authenticated user should be able to access the form for adding a block row block
    Given I am logged in as a user with the <role> role
    When I go to "block/add/block-section"
    Then I should see <message>

    Examples:
    | role            | message         |
    | edit_my_content | "Access denied" |
    | content_editor  | "Create Block Row block" |
    | site_owner      | "Create Block Row block" |
    | administrator   | "Create Block Row block" |
    | developer       | "Create Block Row block" |

@api 
Scenario: An anonymous user should not be able to access the form
  Given I go to "block/add/block-section"
  Then I should see "Access denied"
