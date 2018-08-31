@ExpressContentEditLock
Feature: Express Content Edit Lock
In order to lock content from being edited
As an authenticated user
I should be able to lock users out of editing content
  
#1 Check that only admin and devs can access page.
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

#2 Check
Scenario: An anonymous user should not be able to access the form
  Given I go to "admin/people/lock"
  Then I should see "Access denied"

#3 Fill out the lock form and lock out site owners and content editors
Scenario: An administrator or developer should be able to lock content edits
  Given I am logged in as a user with the "administrator" role
  And I go to "admin/people/lock"
  And I check "Content editors"
  And I check "Site owners"
  And I fill in "edit-lock-allow-users" with "osr-test-owner"
  And I fill in "edit-lock-leave-message" with "We have locked editing of content on this site."
  When I press "Save configuration"
  Then I should see "Lock changes have been saved"

#4 Try to edit a page as a content editor
Scenario: A content editor should not be able to edit content while lock persists
  Given I am logged in as a user with the "content_editor" role
  And I go to "node/1/edit"
  Then I should see "We have locked editing of content on this site."

#5 And now we need to turn off the content lock so other tests can pass
Scenario An administrator or developer should be able to unlock content edits
  Given I am logged in as a user with the "administrator" role
  And I go to "admin/people/lock"
  And I uncheck "Content editors"
  And I uncheck "Site owners"
  When I press "Save configuration"
  Then I should see "Lock changes have been saved"
  