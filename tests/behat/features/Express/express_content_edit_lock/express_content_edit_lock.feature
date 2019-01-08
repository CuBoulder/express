@ExpressContentEditLock
Feature: Express Content Edit Lock
In order to lock content from being edited
As user with the proper role
I should be able to lock users out of editing content

#1 Check that only admin and devs can access content lock page.
Scenario Outline: A user with the proper role should be able to access the form for locking content
  Given I am logged in as a user with the <role> role
  When I go to "admin/people/lock"
  Then I should see <message>

  Examples:
  | role            | message |
  | edit_my_content | "Access denied" |
  | content_editor  | "Access denied" |
  | edit_only       | "Access denied" |
  | site_editor     | "Access denied" |
  | site_owner      | "Access denied" |
  | administrator   | "Users" |
  | developer       | "Users" |

#2 Check that unauthenticated users cannot access content lock page
Scenario: An anonymous user should not be able to access the form
Given I go to "admin/people/lock"
Then I should see "Access denied"

#3 All the roles should be available as choices to lock out
# BECAUSE THE LOGIN NAME APPEARS ON SCREEN, WE CANNOT TEST THAT 'ADMINISTRATOR' DOES NOT SEE THE WORD 'ADMINISTRATOR'
Scenario Outline: A user with the proper role should see all the roles on the Content Edit Lock tab
Given I am logged in as a user with the <role> role
When I go to "admin/people/lock"
Then I should see "Content Editor (deprecated)"
And I should see "Content Editor (edit only)"
And I should see "Edit My Content"
And I should see "Site Editor"
And I should see "Site Owner"
And I should not see <message>

Examples:
| role            | message |
| administrator   | "developer" |
| developer       | "administrator" |


#3 Fill out the lock form and lock out site owners and content editors
Scenario: An administrator or developer should be able to lock content edits
  Given I am logged in as a user with the "administrator" role
  And I go to "admin/people/lock"
  And I check "Site Editor"
  And I check "Site Owner"
  And I fill in "Allow specific users to be exempt from their role's lock" with "site_owner"
  And I fill in "Leave a message for locked out users" with "We have locked editing of content on this site."
  When I press "Save configuration"
  Then I should see "Lock changes have been saved"

#4 Try to edit a page as a site editor
Scenario: A site editor should not be able to edit content while lock persists
  Given I am logged in as a user with the "site_editor" role
  And I go to "node/1/edit"
  Then I should see "We have locked editing of content on this site."
  And the "#edit-title" element should have "disabled" in the "disabled" attribute

#5 Try to edit a page as a site owner
Scenario: The local user 'site_owner' should be able to edit content while lock persists
Given I am on "user"
And I fill in "CU Login Name" with "site_owner"
And I fill in "IdentiKey Password" with "site_owner"
And I press "Log in"
And I go to "node/1/edit"
Then I should see "We have locked editing of content on this site."
And I fill in "Title" with "New Title"
And I press "Save"
Then I should see "Basic page New Title has been updated"

#6 And now we need to turn off the content lock so other tests can pass
Scenario: An administrator or developer should be able to unlock content edits
  Given I am logged in as a user with the "administrator" role
  And I go to "admin/people/lock"
  And I uncheck "Site Editor"
  And I uncheck "Site Owner"
  When I press "Save configuration"
  Then I should see "Lock changes have been saved"
