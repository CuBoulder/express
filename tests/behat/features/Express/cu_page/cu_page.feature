@page @api @editmycontent
Feature: Basic Page Content Type
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete Basic Pages

  
#  CREATE A SIMPLE PAGE NODE
 Scenario: Node Functionality - A very basic Basic Page node can be created 
 Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "My Page"
  And fill in "Body" with "Lorem ipsum dolor sit amet"
  When I press "edit-submit"
 Then I should be on "/my-page"
 And I should see "My Page"
And I should see "Lorem ipsum dolor sit amet"
 
 # 2.5 CHANGE AUTHOR OF THE PAGE NODE
Scenario: Node functionality - Create Revision and Change Authorship of node
Given I am logged in as a user with the "site_owner" role
And I am on "admin/content"
And I follow "My Page"
And I follow "Edit"
 And fill in "Body" with "CU Boulder is a world class university"
# And I fill in "edit-name" with "osr-test-edit-own" 
And I press "Save"
 Then I should see "Basic page My Page has been updated."
 And I should see the link "Revisions"

#THIS TEST IS BROKEN UNTIL AUTHORSHIP CAN BE ASSIGNED ABOVE
Scenario: Node Access -  EditMyContent can edit Basic Pages and Persons if owner; cannot delete; can clear page cache
Given I am logged in as a user with the "edit_my_content" role
And I am on "admin/content"
And I follow "My Page"
Then I should see the link "View"
And I should see the link "Edit"
And I should not see the link "Edit Layout"
And I should see the link "Revisions"
And I should not see the link "Clear Page Cache"
When I follow "Edit"
Then I should see "This document is now locked against simultaneous editing."
And fill in "Body" with "Minds to match our mountains"
And I should not see an "#edit-delete" element
And I press "Save"
 Then I should see "Basic page My Page has been updated."

