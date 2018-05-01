@blocks @roletest
Feature: Hero Unit Block
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete a hero unit block

# 1) TEST BLOCK ADD PRIVILEGES
# 2) TEST THAT A SIMPLE BLOCK CAN BE CREATED AND REVISED
# 3) TEST EDITING AND DELETING PRIVILEGES ON THE BLOCK JUST MADE
# 4) TEST THAT THE DELETE BUTTON ACTUALLY WORKS
# 5) TEST MORE COMPLEX BLOCK CREATION

# 1) TEST BLOCK ADD PRIVILEGES
Scenario Outline: Block Access: Some roles can add a Hero Unit block
Given I am logged in as a user with the <role> role
When I go to "block/add/hero-unit"
Then I should see <message>

Examples:
 | role                    | message                      |
 | developer             | "Create Hero Unit block" |
| administrator         | "Create Hero Unit block" |
| site_owner            | "Create Hero Unit block" |
| content_editor        | "Create Hero Unit block" |
| edit_my_content       | "Access Denied"              |
| site_editor           | "Create Hero Unit block" |
| edit_only             | "Access Denied"              |
| access_manager        | "Access Denied"              |
| configuration_manager | "Access Denied"              |

 Scenario: Block Access: An anonymous user cannot add a Hero Unit block
  When I am on "block/add/hero-unit"
  Then I should see "Access denied"
  
# 2) TEST THAT A SIMPLE BLOCK CAN BE CREATED AND REVISED
 Scenario: Block Functionality - A very simple Hero Unit can be created 
 Given I am logged in as a user with the "site_owner" role
  And I am on "block/add/hero-unit"
  And fill in "edit-label" with "Hero Unit Label"
  And fill in "edit-title" with "My Hero Unit Title"
 And I fill in "edit-field-hero-unit-headline-und-0-value" with "Important Headline"
 And I fill in "edit-field-hero-unit-text-und-0-value" with "Learn more about our program"
  When I press "edit-submit"
  Then I should be on "block/hero-unit-label/view"
 And I should see "My Hero Unit Title"
And I should see "Learn more about our program"
 
#  2.5 CREATE REVISIONS TO THE BLOCK ABOVE
Scenario: Block Functionality - Create Revision of block
Given I am logged in as a user with the "site_owner" role
And I go to "block/hero-unit-label/edit"
And I fill in "edit-field-hero-unit-text-und-0-value" with "A world class university"
 And I press "Save"
 Then I should see "Hero Unit My Hero Unit Title has been updated."

# 3) TEST EDITING AND DELETING PRIVILEGES ON THE BLOCK JUST MADE

Scenario Outline: Block Access - Site Owner and above roles can edit, revise, theme and delete Hero Unit content
Given I am logged in as a user with the <role> role
And I am on "admin/content/blocks"
And I follow "Hero Unit Label"
Then I should see "View"
And I should see "Edit Block"
And I should see "Revisions" 
And I should see "Block Designer"
And I should see "Delete Block"
When I follow "Edit Block"
Then I should see "Edit Hero Unit: Hero Unit Label"
And I should see an "#edit-delete" element
And I follow "View"

Examples: 
| role |
| developer       | 
| administrator   | 
| site_owner      | 
| content_editor  |

Scenario: Block Access - The Site Editor role can edit, revise, and delete Hero Unit content
Given I am logged in as a user with the "site_editor" role
And I am on "admin/content/blocks"
And I follow "Hero Unit Label"
Then I should see "View"
And I should see "Edit Block"
And I should see "Revisions"
And I should not see "Block Designer"
And I should see "Delete Block"
When I follow "Edit Block"
Then I should see "Edit Hero Unit: Hero Unit Label"
And I should see an "#edit-delete" element
And I follow "View"

Scenario: Block Access - The Edit Only role can edit and revise, but not theme or delete Hero Unit content
Given I am logged in as a user with the "edit_only" role
And I am on "admin/content/blocks"
And I follow "Hero Unit Label"
Then I should see "View"
And I should see "Edit Block"
And I should see "Revisions"
And I should not see "Block Designer"
And I should not see "Delete Block"
When I follow "Edit Block"
Then I should see "Edit Hero Unit: Hero Unit Label"
And I should not see an "#edit-delete" element
And I follow "View"

Scenario Outline: Block Access - EditMyContent and the add-on roles cannot by themselves access or edit block content
Given I am logged in as a user with the <role> role
And I am on "admin/content/blocks"
Then I should see "Access denied"
And I go to "block/hero-unit-label/edit"
Then I should see "Access denied"

Examples:
| role              | 
| edit_my_content    |
| access_manager        | 
| configuration_manager | 

# 4) TEST THAT THE DELETE BUTTON ACTUALLY WORKS
Scenario: Verify that the Delete button actually works
 Given I am logged in as a user with the "site_owner" role
And I go to "block/hero-unit-label/edit"
 And I press "Delete"
 Then I should see "Are you sure you want to delete My Hero Unit Title?"
  And I press "Delete"
 Then I should see "Hero Unit My Hero Unit Title has been deleted"
And I am on "/"

# 5) TEST MORE COMPLEX BLOCK CREATION
Scenario: A link, a graphic and an overlay can be added to Hero Unit block
Given I am logged in as a user with the "site_owner" role
 And I am on "block/add/hero-unit"
 And fill in "edit-label" with "My Hero Unit"
 And fill in "edit-title" with "A New Hero Unit"
 And I fill in "edit-field-hero-unit-headline-und-0-value" with "Important News"
 And I fill in "edit-field-hero-unit-text-und-0-value" with "Read More About It"
 And I fill in "edit-field-hero-unit-link-und-0-title" with "Click Here"
 And I fill in "edit-field-hero-unit-link-und-0-url" with "node/1"
 And I attach the file "ralphie.jpg" to "edit-field-hero-unit-image-und-0-upload"
 And I check "edit-field-hero-unit-overlay-und"
 And I press "Save"
 Then I should see "A New Hero Unit"
 And I should see "Important News"
 And I should see the link "Click Here"
 And the response should contain "hero-unit-overlay"

