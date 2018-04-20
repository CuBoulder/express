@api @people
Feature: People List Page Content Type
In order to display a directory list of Person nodes
As an authenticated user
I should be able to create, edit, and delete People List Page content

Scenario Outline: An authenticated user should be able to access the form for adding people list page content
    Given  I am logged in as a user with the <role> role
    When I go to "node/add/people-list-page"
    Then I should see <message>

    Examples:
    | role            | message         |
    | edit_my_content | "Access denied" |
    | content_editor  | "Create People List Page" |
    | site_owner      | "Create People List Page" |
    | administrator   | "Create People List Page" |
    | developer       | "Create People List Page" |

@api @people
Scenario: An anonymous user should not be able to access the form for adding people list page content
  When I am on "node/add/people-list-page"
  Then I should see "Access denied"

 @api @people
  Scenario: The provide menu link box should be checked on node creation but remain unchecked if user chooses to uncheck that box.
    Given  I am logged in as a user with the "site_owner" role
    When I go to "node/add/people-list-page"
      And  I fill in "Title" with "New People List Page"
    Then the "edit-menu-enabled" checkbox should be checked
    When I uncheck "edit-menu-enabled"
      And I press "Save"
      And I follow "Edit"
    Then the checkbox "edit-menu-enabled" should be unchecked
