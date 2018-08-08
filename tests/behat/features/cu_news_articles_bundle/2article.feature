@newsArticles
Feature: News and Articles
In order to post timely news articles and aggregations
As an authenticated user
I should be able to create and tag articles

# 1) TEST NODE ADD PRIVILEGES
Scenario Outline: Node Access - Some roles can add Article content
Given I am logged in as a user with the <role> role
When I go to "node/add/article"
Then I should see <message>

Examples:
 | role                        | message           |
 | developer             | "Create Article" |
| administrator         | "Create Article" |
| site_owner            | "Create Article" |
| content_editor        | "Create Article" |
| edit_my_content    | "Access denied"   |
| site_editor           | "Create Article" |
| edit_only             | "Access denied"       |

 Scenario: Node Access -  An anonymous user cannot add Article content
  When I am on "node/add/article"
  Then I should see "Access denied"
  
# 2) TEST THAT A SIMPLE NODE CAN BE CREATED AND REVISED
 Scenario: Node Functionality - A very simple Article node can be created 
 Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/article"
  And fill in "edit-title" with "An article about Ralphie"
  And fill in "Body" with "Ralphie is the mascot of the University of Colorado"
  When I press "edit-submit"
# Then I should be on "/my-name-of-block-or-node"
 And I should see "An article about Ralphie"
And I should see "Ralphie is the mascot of the University of Colorado"
 
#  2.5 CREATE REVISIONS TO THE NEW NODE
Scenario: Node functionality - Create Revision of node
Given I am logged in as a user with the "site_owner" role
And I am on "admin/content"
And I follow "An article about Ralphie"
And I follow "Edit"
 # BROKEN AT THIS TIME And fill in "edit-name" with "osr-test-edit-own" 
  And fill in "Body" with "Ralphie is actually a bison."
 And I press "Save"
 Then I should see "Article An article about Ralphie has been updated."
  And I should see the link "Revisions"

# 3) TEST EDITING AND DELETING PRIVILEGES ON THE NODE JUST MADE

Scenario Outline: Node Access -  Some roles can edit and delete Article node content
Given I am logged in as a user with the <role> role
And I am on "admin/content"
And I follow "An article about Ralphie"
Then I should see the link "View"
And I should see the link "Edit"
And I should see the link "Edit Layout"
And I should see the link "Revisions"
And I should see the link "Clear Page Cache"
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

Scenario: Node Access - EditOnly can edit and revise but not delete node; can clear page cache
Given I am logged in as a user with the "edit_only" role
And I am on "admin/content"
And I follow "An article about Ralphie"
Then I should see the link "View"
And I should see the link "Edit"
And I should not see the link "Edit Layout"
And I should see the link Revisions"
And I should see the link Clear Page Cache"
When I follow "Edit"
Then I should see "This document is now locked against simultaneous editing."
And I should not see an "#edit-delete" element
And I press "Cancel edit"

# EDIT MY CONTENT: ALL OTHER NODES 
Scenario: Node Access - EditMyContent can not edit Article nodes
Given I am logged in as a user with the "edit_my_content" role
And I am on "admin/content"
And I follow "An article about Ralphie"
Then I should see the link "View"
And I should not see the link "Edit"
And I should not see the link "Clear Page Cache"

# 4) TEST THAT THE DELETE BUTTON ACTUALLY WORKS
 Scenario: Node Functionality - Verify that the Delete button actually works
 Given I am logged in as a user with the "site_owner" role
And I am on "admin/content"
And I follow "An article about Ralphie"
And I follow "Edit"
 And I press "Delete"
 Then I should see "Are you sure you want to delete An article about Ralphie?"
  And I press "Delete"
 Then I should see "Article An article about Ralpie has been deleted"
And I am on "/"

# 5) TEST MORE COMPLEX NODE CREATION
# specific node tests here
 # Scenario: Node Function
