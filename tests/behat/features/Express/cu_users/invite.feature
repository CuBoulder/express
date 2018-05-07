@users
Feature: User External Invite
Given I am an administrator
When I login to a Web Express site
I should be able to invite users to my site

#SOME ROLES CAN ACCESS USER PAGE

Scenario Outline: Only Devs, Admins, SOs and AcsMgrs can view Users page
Given I am logged in as a user with the <role> role
When I go to "admin/people"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Users" |
| administrator    | "Users" |
| site_owner       | "Users" |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "Access denied" |
| edit_only        | "Access denied" |
| access_manager   | "Users" |
| configuration_manager | "Access denied" |

Scenario: An anonymous user should not be able to view Users page
  When I am on "admin/people"
  Then I should see "Access denied"

Scenario Outline: Only Devs, Admins, SOs and AcsMgrs can Invite Users
Given I am logged in as a user with the <role> role
When I go to "admin/people/invite"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Invite New User" |
| administrator    | "Invite New User" |
| site_owner       | "Invite New User" |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "Access denied" |
| edit_only        | "Access denied" |
| access_manager   | "Invite New User" |
| configuration_manager | "Access denied" |

Scenario: An anonymous user should not be able to Invite Users
  When I am on "admin/people/invite"
  Then I should see "Access denied"
  
Scenario Outline: Only Devs, Admins, SOs and AcsMgrs can Manage Invites
Given I am logged in as a user with the <role> role
When I go to "admin/people/invite/operations"
Then I should see <message>

Examples:
| role             | message |
| developer        | "No invites available." |
| administrator    | "No invites available." |
| site_owner       | "No invites available." |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "Access denied" |
| edit_only        | "Access denied" |
| access_manager   | "No invites available." |
| configuration_manager | "Access denied" |

Scenario: An anonymous user should not be able to Manage Invites
  When I am on "admin/people/invite/operations"
  Then I should see "Access denied"
  
Scenario Outline: Only Devs can access the Add User page
Given I am logged in as a user with the <role> role
When I go to "admin/people/create"
Then I should see <message>

Examples:
| role             | message |
| developer        | "This web page allows administrators to register new users" |
| administrator    | "Access denied" |
| site_owner       | "Access denied" |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "Access denied" |
| edit_only        | "Access denied" |
| access_manager   | "Access denied" |
| configuration_manager | "Access denied" |


Scenario: Invite page has input fields for sending invites.
    Given I am logged in as a user with the "site_owner" role
    When I go to "admin/people/invite"
    Then I should see a "#edit-rid" element
    And I should see a "#edit-email" element
    And I should see a "#edit-custom-message" element


 Scenario: A developer can access the user invite configuration form.
    Given I am logged in as a user with the "developer" role
    When I go to "admin/config/people/invite"
    Then I should see "Number of days invites are valid"
      And I should see "Invitation Accepted Email Template"


