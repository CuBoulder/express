@users @usertabs
Feature: Each User Page is populated with several tabs of informational content
When I am on the User pages
As an authenticated user with the proper role
I see a set of tabs populated with information about my users

Scenario Outline: Only certain roles have access to the User pages
Given I am logged in as a user with the <role> role
# Scenario: Only certain roles have access to the User pages
# Given I am logged in as a user with the "site_owner" role
And I am on "admin/people"
Then print last response
# The following targets the first user in the user table cuz we don't know ID
When I click the ".views-field-edit-node a" element
Then I should see the link "Authored Content"
And I should see the link "Edited Content"
And I should see the link "Broken links"
And I should see the link "Locked documents"

Examples:
  | role             |
  | site_owner       |
 | administrator    |
 | developer      |

Scenario Outline: Some roles cannot access the individual User pages
Given I am logged in as a user with the <role> role
And I am on "admin/people"
Then I should see "Access denied"

Examples:
    | role             |
    | site_editor      |
    | content_editor   |
    | edit_my_content  |

Scenario: The user tabs should not be blank
Given I am logged in as a user with the "site_owner" role
And I am on "admin/people"
# The following targets the first user in the user table cuz we don't know ID
When I click the ".views-row-first .views-field-edit-node a" element
And I follow "Roles"
Then I should see "Edit My Content"
And I should see "Content Editor"
And I should see "Site Editor"
And I should see "Site Owner"
And I should see "Add-on Roles"
And I follow "Authored Content"
Then I should see "OPERATIONS"
And I follow "Edited Content"
Then I should see "OPERATIONS"
And I follow "Broken links"
Then I should see "No broken links have been found."
# Hiding the following check for now as Behat won't follow
# And I follow "Locked documents"
# Then I should see "Below is a list of all documents locked by you"
