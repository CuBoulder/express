@ExpressContentEditLock
Feature: Express Content Edit Lock
In order to lock content from being edited
As an authenticated user
I should be able to lock users out of editing content
  
 @express-content-edit-lock
Scenario Outline: An authenticated user should be able to access the form for locking content
    Given I am logged in as a user with the <role> role
    When I go to "admin/people/lock"
    Then I should see <message>

    Examples:
    | role            | message         |
    | edit_my_content | "Access denied" |
    | content_editor  | "Access denied" |
    | site_owner      | "Access denied" |
    | administrator   | "Users" |
    | developer       | "Users" |

 @express-content-edit-lock
Scenario: An anonymous user should not be able to access the form
  Given I go to "admin/people/lock"
  Then I should see "Access denied"

 @javascript
Scenario: An administrator or developer should be able to lock content edits
Given I am logged in as a user with the "administrator" role
And I go to "admin/people/lock"
And I check "edit-lock-by-role-10"
And I check "edit-lock-by-role-11"
And I fill in "edit-lock-allow-users" with "osr-test-owner"
And I fill in "edit-lock-leave-message" with "We have locked editing of content on this site."
And I press "Save configuration"
And I should see "Lock has been enabled."
