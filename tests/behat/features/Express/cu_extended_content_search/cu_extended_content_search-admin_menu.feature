Feature: CU Extended Content Search Menu
  When I log into the website
  As an authenticated user
  I should be able to see the correct menu and shortcuts.
  
 @api @extended_search
 Scenario Outline: All roles should see the blue and white toolbars
  Given I am logged is as a user with the <role> role
  When I go to "/"
  Then I should see "navbar-bar"
  And I should see "navbar-item--2-tray"

  Examples:
    | role |
    | developer |
    | administrator |
    | site_owner |
    | content_editor |
    | edit_my_content |


@api @extended_search @broken
Scenario Outline: All roles should see a blue toolbar with the same five links
 Given  I am logged in as a user with the <role> role
 When I go to "/"
 Then I should see the link "Express"
 And I should see the link "Shortcuts"
 And I should see the link "My account"
 And I should see the link "Help"
 And I should see the link "Log out"

Examples:
     | role |
     | developer |
     | administrator |
     | site_owner |
     | content_editor |
 

#CHECKING THE EXPRESS MENU

  @api @extended_search
  Scenario: As a developer I should see the complete Express menu
    Given  I am logged in as a user with the "developer" role
    When I go to "admin"
    Then I should see "Dashboard"
      And I should see "Content"
      And I should see "Structure"
      And I should see "Appearance"
      And I should see "Users"
      And I should see "Modules"
      And I should see "Configuration"
      And I should see "Reports"
      And I should see "Design"
      And I should see "Settings"
      And I should see "Help"

  @api @extended_search
  Scenario Outline: As a site_owner or an administrator I should see a partial Express menu
    Given  I am logged in as a user with the <role> role
    When I go to "admin"
    Then I should see "Dashboard"
      And I should see "Content"
      And I should see "Structure"
      And I should see "Users"
      And I should see "Design"
      And I should see "Settings"

    Examples:
    | role |
    | administrator |
    | site_owner |

  @api @extended_search
  Scenario: As a content_editor I should see a limited Express menu
   Given  I am logged in as a user with the "content_editor" role
   When I go to "admin"
   Then I should see "Dashboard"
      And I should see "Content"
      And I should see "Structure"
      And I should see "Settings"
      
  @api @extended_search
  Scenario: As an edit_my_content I should see an extremely limited Express menu
   Given I am logged in as a user with the "edit_my_content" role
   When I go to "admin"
   Then I should see "Access Denied"
   And I should see "Dashboard"
   And I should see "Content"
    
  @api @extended_search @broken
  Scenario Outline: Most user roles should see the same Shortcuts menu
    Given  I am logged in as a user with the <role> role
    When I am on "/"
    And I click "Shortcuts"
    Then I should see "Add content"
    And I should see "Find content"
    And I should see "Blocks"
    And I should see "Context"
    And I should see "Main Menu"
    And I should see "Edit shortcuts"

    Examples:
      | role |
      | developer |
      | administrator |
      | site_owner |
      | content_editor |

   @api @extended_search
  Scenario: An edit_my_content user should see a very limited Shortcuts menu
    Given  I am logged in as a user with the "edit_my_content" role
   When I am on "/"
    And I click "Shortcuts"
    And I should see "Find content"
