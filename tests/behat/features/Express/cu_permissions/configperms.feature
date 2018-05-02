@config @roletest
Feature: Permissions for Configuration and Settings 

Scenario Outline: Most roles cannot access the Admin/Configuration page
Given I am logged in as a user with the <role> role
When I go to "admin/config"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Configuration" |
| administrator    | "Access denied" |
| site_owner       | "Access denied" |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "Access denied" |
| edit_only        | "Access denied" |
| access_manager   | "Access denied" |
| configuration_manager | "Access denied" |

Scenario Outline: Most roles cannot access the Admin/Settings page
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

Scenario Outline: Most roles cannot Set the Site Name
Given I am logged in as a user with the <role> role
When I go to "admin/settings/site-configuration/site-name"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Site Name" |
| administrator    | "Site Name" |
| site_owner       | "Site Name" |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "Access denied" |
| edit_only        | "Access denied" |
| access_manager   | "Access denied" |
| configuration_manager | "Site Name" |

Scenario Outline: Most roles cannot Set the Site Description
Given I am logged in as a user with the <role> role
When I go to "admin/settings/site-configuration/site-description"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Site Description" |
| administrator    | "Site Description" |
| site_owner       | "Site Description" |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "Access denied" |
| edit_only        | "Access denied" |
| access_manager   | "Access denied" |
| configuration_manager | "Site Description" |

Scenario Outline: Most roles cannot Set the Contact Information
Given I am logged in as a user with the <role> role
When I go to "admin/settings/site-configuration/contact"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Contact Information" |
| administrator    | "Contact Information" |
| site_owner       | "Contact Information" |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "Access denied" |
| edit_only        | "Access denied" |
| access_manager   | "Access denied" |
| configuration_manager | "Contact Information" |




