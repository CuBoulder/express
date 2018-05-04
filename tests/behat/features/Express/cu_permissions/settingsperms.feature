@perms @roletest
Feature: The Settings page lists the configuration options for all the enabled bundles
When I am on the admin/settings page
As a user with the proper role
I should be able to set the site name, enable bundles and other configurations as defined

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

#THIS IS JUST A QUICK TEST TO MAKE SURE THE ABOVE SCENARIO RAN RIGHT
Scenario: Site Editor can't set site settings
Given I am logged in as a user with the "site_editor" role
When I go to "admin/settings/site-configuration/site-name"
Then I should see "Access denied"


