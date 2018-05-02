@config @roletest
Feature: Configuration Permissions

Scenario Outline: Some roles can access the Configuration page
Given I am logged in as a user with the <role> role
When I go to "admin/config"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Configuration" |
| administrator    | "Configuration" |
| site_owner       | "Configuration" |
| content_editor   | "Configuration" |
| edit_my_content  | "Access denied" |
| site_editor      | "Configuration" |
| edit_only        | "Configuration" |
| access_manager | "Access denied" |
| configuration_manager | "Configuration" |
