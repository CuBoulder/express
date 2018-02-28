Feature: Block Row Block
In order to create interesting displays of content
Authenticated users with proper role should be able to
Use the Block Row Block to create and place other blocks side by side.

@api @block-row-block
Scenario Outline: An authenticated user should be able to access the form for adding a block row block
    Given  I am logged in as a user with the <role> role
    When I go to "block/add/block-row"
    Then I should not see <message>

    Examples:
    | role           | message         |
    | content_editor | "Access denied" |
    | site_owner     | "Access denied" |
    | administrator  | "Access denied" |
    | developer      | "Access denied" |

@api @block-row-block
Scenario: An user with Edit My Content role should not be able to access the form
  Given I am logged in as a user with the edit_my_content role
  When I go to "block/add/block-row"
  Then I should see "Access denied"
  
@api @block-row-block
Scenario: An anonymous user should not be able to access the form
  Given I am logged in as an anonymous user
  When I go to "block/add/block-row"
  Then I should see "Access denied"
