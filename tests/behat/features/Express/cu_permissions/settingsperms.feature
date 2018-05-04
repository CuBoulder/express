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

Scenario Outline: EMCs and AMs cannot access Admin/Settings page; all others can
Given I am logged in as a user with the <role> role
When I go to "admin/settings"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Settings" |
| administrator    | "Settings" |
| site_owner       | "Settings" |
| content_editor   | "Settings" |
| edit_my_content  | "Access denied" |
| site_editor      | "Settings" |
| edit_only        | "Settings" |
| access_manager   | "Access denied" |
| configuration_manager | "Settings" |


# SITE CONFIGURATION 

Scenario Outline: Only Devs, Admins, SOs and CMs can Enable Bundles
Given I am logged in as a user with the <role> role
When I go to "admin/settings/bundles/list"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Configure Bundles" |
| administrator    | "Configure Bundles" |
| site_owner       | "Configure Bundles" |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "Access denied" |
| edit_only        | "Access denied" |
| access_manager   | "Access denied" |
| configuration_manager | "Configure Bundles" |


# URL MANAGEMENT

Scenario Outline: Devs, Admins, SOs, SEs and CMs can Create URL Redirects
Given I am logged in as a user with the <role> role
When I go to "admin/config/search/redirect"
Then I should see <message>

Examples:
| role             | message |
| developer        | "URL redirects" |
| administrator    | "URL redirects" |
| site_owner       | "URL redirects" |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "URL redirects" |
| edit_only        | "Access denied" |
| access_manager   | "Access denied" |
| configuration_manager | "URL redirects" |


# CACHE

Scenario Outline: EMCs and AMs cannot Cache Clear options; all other roles can
Given I am logged in as a user with the <role> role
When I go to "admin/settings/cache/clear"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Which Cache to Clear?" |
| administrator    | "Which Cache to Clear?" |
| site_owner       | "Which Cache to Clear?" |
| content_editor   | "Which Cache to Clear?" |
| edit_my_content  | "Access denied" |
| site_editor      | "Which Cache to Clear?" |
| edit_only        | "Which Cache to Clear?" |
| access_manager   | "Access denied" |
| configuration_manager | "Which Cache to Clear?" |

Scenario Outline: EMCs and AMs cannot Clear Cache By Page; all other roles can
Given I am logged in as a user with the <role> role
When I go to "admin/settings/cache/clear/varnish-path"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Path To Clear" |
| administrator    | "Path To Clear" |
| site_owner       | "Path To Clear" |
| content_editor   | "Path To Clear" |
| edit_my_content  | "Access denied" |
| site_editor      | "Path To Clear" |
| edit_only        | "Path To Clear" |
| access_manager   | "Access denied" |
| configuration_manager | "Path To Clear" |


# SEARCH SETTINGS

Scenario Outline: Only Devs, Admins, SOs and CMs can set Site Search Settings options
Given I am logged in as a user with the <role> role
When I go to "admin/settings/search/search-settings"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Site Search Settings" |
| administrator    | "Site Search Settings" |
| site_owner       | "Site Search Settings" |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "Access denied" |
| edit_only        | "Access denied" |
| access_manager   | "Access denied" |
| configuration_manager | "Site Search Settings" |

