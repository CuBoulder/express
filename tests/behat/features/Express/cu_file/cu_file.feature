@file
Feature: File Content Type
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete File content

# 1) TEST NODE ADD PRIVILEGES
# 2) TEST THAT A SIMPLE NODE CAN BE CREATED AND REVISED
# 3) TEST EDITING AND DELETING PRIVILEGES ON THE NODE JUST MADE
# 4) TEST THAT THE DELETE BUTTON ACTUALLY WORKS
# 5) TEST MORE COMPLEX NODE CREATION

# 1) TEST NODE ADD PRIVILEGES
Scenario Outline: Node Access - Some roles can add File content
Given I am logged in as a user with the <role> role
When I go to "node/add/file"
Then I should see <message>

Examples:
 | role                             | message                      |
 | developer             | "Create File" |
| administrator         | "Create File" |
| site_owner            | "Create File" |
| content_editor        | "Create File" |
| edit_my_content       | "Access Denied"              |
| site_editor           | "Create File" |
# | edit_only             | "Access Denied"              |
# | access_manager        | "Access Denied"              |
# | configuration_manager | "Access Denied"              |

 Scenario: FAQ Access -  An anonymous user cannot add File content
  When I am on "node/add/file"
  Then I should see "Access denied"
  
# 2) TEST THAT A SIMPLE NODE CAN BE CREATED AND REVISED
 Scenario: Node Functionality - A simple File can be created; with secure https URL
 Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/file"
  And fill in "edit-title" with "My File"
  And I fill in "edit-body-und-0-value" with "A photo of Ralphie and handlers"
  And I attach the file "ralphie.jpg" to "edit-field-file-attachment-und-0-upload"
  And I press "Upload"
    # And I wait for AJAX
  Then I should see "File Information"
  And I should see "Operations"
  And I press "edit-submit"
  Then I should be on "/my-file"
  And I should see "A user without editing permissions would have been redirected"
  And I should see "My File"
  And I should see "Access the top file listed below with the following url"
# NEXT LINE: CHECKING FOR HTTPS://
  And I should not see "http://www.colorado.edu"
 
#  2.5 CREATE REVISIONS TO THE NODE ABOVE
Scenario: Node functionality - Create Revision and Change Authorship of node
Given I am logged in as a user with the "site_owner" role
And I am on "admin/content"
And I follow "My File"
And I follow "Edit"
 # BROKEN AT THIS TIME And fill in "edit-name" with "osr-test-edit-own" 
 And I fill in "body[und][0][value]" with "A Scenic Photo"
 And I press "Save"
 Then I should see "File My File has been updated."

# 3) TEST EDITING AND DELETING PRIVILEGES ON THE NODE JUST MADE

Scenario Outline: Node Access -  Some roles can edit and delete node content
Given I am logged in as a user with the <role> role
And I am on "admin/content"
And I follow "My File"
Then I should see "View"
And I should see "Edit"
And I should see "Revisions"
And I should see "Clear Page Cache"
When I follow "Edit"
Then I should see "This document is now locked against simultaneous editing."
And I should see an "#edit-delete" element
And I press "Cancel edit"

Examples: 
| role |
| developer       | 
| administrator   | 
| site_owner      | 
| content_editor  |
| site_editor |

Scenario: Node Access -  Edit Only can edit but not delete node; can clear page cache
Given I am logged in as a user with the "edit_only" role
And I am on "admin/content"
And I follow "My File"
Then I should see "View"
And I should see "Edit"
And I should not see "Revisions"
And I should see "Clear Page Cache"
When I follow "Edit"
Then I should see "This document is now locked against simultaneous editing."
And I should not see an "#edit-delete" element
And I press "Cancel edit"

@broken
#THIS TEST IS BROKEN UNTIL AUTHORSHIP CAN BE ASSIGNED ABOVE
Scenario: Node Access -  Edit My Content can edit but not delete node; can clear page cache
Given I am logged in as a user with the "edit_my_content" role
And I am on "admin/content"
And I follow "My File"
Then I should see "View"
And I should see "Edit"
And I should not see "Revisions"
And I should not see "Clear Page Cache"
When I follow "Edit"
Then I should see "This document is now locked against simultaneous editing."
And I should not see an "#edit-delete" element
And I press "Cancel edit"

# Scenario Outline: Node Access -  The add on roles cannot by themselves access content
# Given I am logged in as a user with the <role> role
# And I am on "admin/content"
# Then I should see "Access denied"

# Examples:
# | role                 | 
# | access_manager        | 
# | configuration_manager | 

# 4) TEST THAT THE DELETE BUTTON ACTUALLY WORKS
Scenario: Verify that the Delete button actually works
 Given I am logged in as a user with the "site_owner" role
And I am on "admin/content"
And I follow "My File"
And I follow "Edit"
 And I press "Delete"
 Then I should see "Are you sure you want to delete My File?"
 And I press "Delete"
 Then I should see "File My File has been deleted"
And I am on "/"


# 5) TEST MORE COMPLEX NODE CREATION

Scenario: The File Content Type verifies that a file has been uploaded
 Given I am logged in as a user with the "site_owner" role
  When I go to "node/add/file"
   And I fill in "edit-title" with "Test Page"
    And I fill in "body[und][0][value]" with "Do not keep this page"
    And I press "Save"
   Then I should see "File Attachment field is required."
    
