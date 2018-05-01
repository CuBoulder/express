@blocks @roletest
Feature: Text Block Block
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete a text block

# 1) TEST BLOCK ADD PRIVILEGES
# 2) TEST THAT A SIMPLE BLOCK CAN BE CREATED AND REVISED
# 3) TEST EDITING AND DELETING PRIVILEGES ON THE BLOCK JUST MADE
# 4) TEST THAT THE DELETE BUTTON ACTUALLY WORKS
# 5) TEST MORE COMPLEX BLOCK CREATION

# 1) TEST BLOCK ADD PRIVILEGES
Scenario Outline: Block Access: Some roles can add a Text Block block
Given I am logged in as a user with the <role> role
When I go to "block/add/block"
Then I should see <message>

Examples:
 | role                             | message                      |
 | developer             | "Create Text Block block" |
| administrator         | "Create Text Block block" |
| site_owner            | "Create Text Block block" |
| content_editor        | "Create Text Block block" |
| edit_my_content       | "Access Denied"              |
| site_editor           | "Create Text Block block" |
| edit_only             | "Access Denied"              |
| access_manager        | "Access Denied"              |
| configuration_manager | "Access Denied"              |

 Scenario: Block Access: An anonymous user cannot add a Text Block block
  When I am on "block/add/block"
  Then I should see "Access denied"
  
# 2) TEST THAT A SIMPLE BLOCK CAN BE CREATED AND REVISED
 Scenario: Block Functionality - A very simple Text Block can be created 
 Given I am logged in as a user with the "site_owner" role
  And I am on "block/add/block"
  And fill in "edit-label" with "Text Block Label"
  And fill in "edit-title" with "My Text Block Title"
And fill in "Body" with "An informative block of text about our program"
  When I press "edit-submit"
  Then I should be on "block/text-block-label/view"
 And I should see "My Text Block Title"
 And I should see "An informative block of text about our program"
 
#  2.5 CREATE REVISIONS TO THE BLOCK ABOVE
Scenario: Block Functionality - Create Revision of block
Given I am logged in as a user with the "site_owner" role
And I am on "admin/content/blocks"
And I follow "Text Block Label"
And I follow "Edit Block"
And fill in "Body" with "Academics, Research and Student Life"
 And I press "Save"
 Then I should see "Text Block My Text Block Title has been updated."

# 3) TEST EDITING AND DELETING PRIVILEGES ON THE BLOCK JUST MADE

Scenario Outline: Block Access - Site Owner and above roles can edit, revise, theme and delete Text Block content
Given I am logged in as a user with the <role> role
And I am on "admin/content/blocks"
And I follow "Text Block Label"
Then I should see "View"
And I should see "Edit Block"
And I should see "Revisions" 
And I should see "Block Designer"
And I should see "Delete Block"
When I follow "Edit Block"
Then I should see "Edit Text Block: Text Block Label"
And I should see an "#edit-delete" element
And I follow "View"

Examples: 
| role |
| developer       | 
| administrator   | 
| site_owner      | 
| content_editor  |

Scenario: Block Access - The Site Editor role can edit, revise, and delete Text Block content
Given I am logged in as a user with the "site_editor" role
And I am on "admin/content/blocks"
And I follow "Text Block Label"
Then I should see "View"
And I should see "Edit Block"
And I should see "Revisions"
And I should not see "Block Designer"
And I should see "Delete Block"
When I follow "Edit Block"
Then I should see "Edit Text Block: Text Block Label"
And I should see an "#edit-delete" element
And I follow "View"

Scenario: Block Access - The Edit Only role can edit and revise, but not theme or delete Text Block content
Given I am logged in as a user with the "edit_only" role
And I am on "admin/content/blocks"
And I follow "Text Block Label"
Then I should see "View"
And I should see "Edit Block"
And I should see "Revisions"
And I should not see "Block Designer"
And I should not see "Delete Block"
When I follow "Edit Block"
Then I should see "Edit Text Block: Text Block Label"
And I should not see an "#edit-delete" element
And I follow "View"

@broken
#THIS TEST IS BROKEN UNTIL AUTHORSHIP CAN BE ASSIGNED ABOVE - WAIT BLOCKS DON'T HAVE OWNERSHIP
# NAIL DOWN BLOCK OWNERSHIP
Scenario: Block Access -  Edit My Content can edit but not delete node; can clear page cache
Given I am logged in as a user with the "edit_my_content" role
And I am on "admin/content/blocks"
And I follow "Text Block Label"
Then I should see "View"
And I should see "Edit Block"
And I should not see "Edit Layout"
And I should not see "Revisions"
And I should not see "Clear Page Cache"
When I follow "Edit Block"
Then I should see "Edit Text Block: Text Block Label"
And I should not see an "#edit-delete" element
And I follow "View"

Scenario Outline: Block Access - The add-on roles cannot by themselves access or edit block content
Given I am logged in as a user with the <role> role
And I am on "admin/content/blocks"
Then I should see "Access denied"
And I go to "block/text-block-label/edit"
Then I should see "Access denied"

Examples:
| role              | 
| access_manager        | 
| configuration_manager | 

# 4) TEST THAT THE DELETE BUTTON ACTUALLY WORKS
Scenario: Verify that the Delete button actually works
 Given I am logged in as a user with the "site_owner" role
And I go to "block/text-block-label/edit"
 And I press "Delete"
 Then I should see "Are you sure you want to delete My Text Block Title?"
  And I press "Delete"
 Then I should see "Text Block My Text Block Title has been deleted"
And I am on "/"

# 5) TEST MORE COMPLEX BLOCK CREATION

# NOTE THAT THE INSERT BUTTON IS IMPOSSIBLE TO TARGET AT THIS TIME
@api
Scenario: A graphic can be uploaded to a Text Block
  Given I am logged in as a user with the "site_owner" role
  And I am on "block/add/block"
  And fill in "edit-label" with "My Text Block"
  And fill in "edit-title" with "My New Text Block"
  And fill in "Body" with "Lorem ipsum dolor sit amet"
  And I attach the file "cupcakes.jpg" to "edit-field-block-photo-und-0-upload"
  And I fill in "edit-field-block-photo-und-0-alt" with "Lavender and lemony goodness"
  And I press "edit-field-block-photo-und-0-upload-button"
 Then I should see "File information"
 And I press "Save"
 Then I should see "My New Text Block"
 And I should see "Lorem ipsum dolor sit amet"
