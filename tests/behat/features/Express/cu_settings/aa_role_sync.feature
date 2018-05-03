@settings
Feature: The Settings page lists the configuration options for all the enabled bundles
In order to test the new roles in Web Express
As a user with the proper role
The system should sync/unsync with secure permissions

Scenario: Roles can be assigned their new permissions
Given I am logged in as a user with the "developer" role
And I am on "admin/config/people/secure_permissions"
And I check "edit-secure-permissions-sync-roles"
And I press "edit-submit"
Then I should see "The configuration options have been saved."
And I uncheck "edit-secure-permissions-sync-roles"
And I press "edit-submit"
Then I should see "The configuration options have been saved."
And I press "edit-submit"
Then I should see "The configuration options have been saved."
