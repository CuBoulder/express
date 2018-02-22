Feature: CU Extended Content Search Menu
  When I log into the website
  As an content editor, site owner, administrator or developer
  I should be able to see the correct menu and shortcuts.

  @api @extended_search
  Scenario: As a developer I should see the complete menu
    Given  I am logged in as a user with the "developer" role
    When I follow "Admin menu"
    Then I should see "Content"
      And I should see "Structure"
      And I should see "Appearance"
      And I should see "Users"
      And I should see "Modules"
      And I should see "Configuration"
      And I should see "Reports"
      # @todo Find out why Settings isn't a link.
      And I should see "Settings"
      And I should see "Design"
      And I should see "Help"

  @api @extended_search
  Scenario Outline: As a site_owner or an administrator I should see a partial menu
    Given  I am logged in as a user with the <role> role
    When I go to "user"
    Then I should see "Content"
      And I should see "Structure"
      And I should see "Users"
      And I should see "Settings"
      And I should see "Design"
      And I should see "Help"

    Examples:
    | role |
    | administrator |
    | site_owner |

  @api @extended_search
  Scenario: As a content_editor I should see a limited menu
    Given  I am logged in as a user with the "content_editor" role
    When I go to "user"
    Then I should see "Express"
      And I should see "Shortcuts"
      And I should see "Help"
      And I should see "Log out"

  @api @extended_search @broken
  Scenario Outline: As an authenticated user with a role I should see a partial menu
    Given  I am logged in as a user with the <role> role
    When I follow "Shortcuts"
    Then I should see "Add content"
      And I should see "Find content"
      And I should see "Context"
    And I should see "Edit shortcuts"

    Examples:
      | role |
      | developer |
      | administrator |
      | site_owner |
      | content_editor |

  @api @extended_search @broken
  Scenario: As a developer I should see extra links in the shortcuts menu
    Given  I am logged in as a user with the "developer" role
    When I follow"Shortcuts"
      # @todo figure out why these links aren't showing up.
      Then I should see "Configuration"
      Then I should see "Reports"

