Feature: Advanced Layout Bundle

  @api @advanced_layout
  Scenario: A content editor should be able to place a bean as a block.
    Given  CU - I am logged in as a user with the "content_editor" role
    When I go to "node/1"
      And I click "Edit Layout"

