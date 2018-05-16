@users
Feature: User External Invite
Given I am an administrator
When I login to a Web Express site
I should be able to invite users to my site and manage invitations

#SOME ROLES CAN ACCESS USER PAGE

Scenario Outline: Access - Only Devs, Admins, SOs and AcsMgrs can view Users page
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
| configuration_manager | "Users" |

Scenario: Access - An anonymous user should not be able to view Users page
  When I am on "admin/people"
  Then I should see "Access denied"

Scenario Outline: Access - Only Devs, Admins, SOs and AcsMgrs can Invite Users
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

Scenario: Access - An anonymous user should not be able to Invite Users
  When I am on "admin/people/invite"
  Then I should see "Access denied"
  
Scenario Outline: Access - Only Devs, Admins, SOs and AcsMgrs can Manage Invites
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

Scenario: Access - An anonymous user should not be able to Manage Invites
  When I am on "admin/people/invite/operations"
  Then I should see "Access denied"
  
Scenario Outline: Access - Only Devs can access the Add User page
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

Scenario: Access -  A developer can access the user invite configuration form.
Given I am logged in as a user with the "developer" role
When I go to "admin/config/people/invite"
Then I should see "Number of days invites are valid"
And I should see "Invitation Accepted Email Template"

# INVITATIONS WORK AS EXPECTED

Scenario: Functionality - Users landing page is properly populated with fields for finding and sorting users
Given I am logged in as a user with the "site_owner" role
When I go to "admin/people"
Then I should see "Name"
And I should see an "#edit-combine" element
And I should see "Role"
And I should see an "#edit-rid-op" element
 And I should see "Active"
  And I should see an "#edit-status" element
  And I should see an "#edit-submit-cu-people-administration-override-view" element
  And I should see a "#edit-reset" element
  And I should see the link "sort by Username"
  And I should see the link "sort by Active"
# HIDING FOR NOW And I should see the link "sort by Primary Affiliation"
  And I should see the link "sort by Member for"
  And I should see the link "sort by Last access"
     
Scenario: Functionality - Invite page has input fields for sending invites.
Given I am logged in as a user with the "site_owner" role
When I go to "admin/people/invite"
Then I should see a "#edit-rid" element
And I should see a "#edit-email" element
And I should see a "#edit-custom-message" element

Scenario: Functionality - Sending an invitation
Given I am logged in as a user with the "site_owner" role
When I go to "admin/people/invite"
And I fill in "edit-email" with "newname@example.com"
And I press "edit-submit"
Then I should see "Successfully invited new user!"

Scenario: Functionality - Cancelling an invitation
Given I am logged in as a user with the "site_owner" role
When I go to "admin/people/invite/operations"
Then I should see "newname@example.com"
When I check "edit-table-0" 
And I press "edit-submit"
Then I should see "Deleted 1 user invite."
