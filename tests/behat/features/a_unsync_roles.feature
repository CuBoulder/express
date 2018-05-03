@unsyncroles
Feature: Secure permissions Role Sync

Scenario: Roles can be unsynched
Given I am logged in as a user with the "developer" role
And I am on "admin/config/people/secure_permissions"
And I check "#edit-secure-permissions-sync-roles"
And I press "#edit-submit"
Then I should see "The configuration options have been saved."
And I uncheck "edit-secure-permissions-sync-roles"
And I press "#edit-submit"
Then I should see "The configuration options have been saved."
And I press "#edit-submit"
Then I should see "The configuration options have been saved."

Scenario: Site Editor can't set site settings
Given I am logged in as a user with the "site_editor" role
When I go to "admin/settings/site-configuration/site-name"
Then I should see "Access denied"
