@config @roletest
Feature: Permissions for Configuration and Settings 

Scenario Outline: Most roles cannot access the Admin/Configuration page
Given I am logged in as a user with the <role> role
When I go to "admin/config"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Configuration" |
| administrator    | "Configuration" |
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

Scenario Outline: Most roles cannot Set the Google Analytics ID
Given I am logged in as a user with the <role> role
When I go to "admin/settings/site-configuration/google-analytics"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Google Analytics" |
| administrator    | "Google Analytics" |
| site_owner       | "Google Analytics" |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "Access denied" |
| edit_only        | "Access denied" |
| access_manager   | "Access denied" |
| configuration_manager | "Google Analytics" |

Scenario Outline: Most roles cannot Configure Bundles
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

Scenario Outline: Most roles cannot Create URL Redirects
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
| site_editor      | "Access denied" |
| edit_only        | "Access denied" |
| access_manager   | "Access denied" |
| configuration_manager | "URL redirects" |

Scenario Outline: Some roles can see Cache Clear options
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

Scenario Outline: Some roles can Clear Cache By Page
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





