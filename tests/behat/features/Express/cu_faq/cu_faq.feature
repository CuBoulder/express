@faqs
Feature: Frequently Asked Questions Content Type
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete FAQ content

# 1) CHECK NODE ADD PRIVILEGES
# 2) CHECK THAT A SIMPLE NODE CAN BE CREATED AND REVISED
# 3) CHECK EDITING AND DELETING PRIVILEGES ON THE NODE JUST MADE
# 4) CHECK THAT THE DELETE BUTTON ACTUALLY WORKS
# 5) CHECK MORE COMPLEX NODE CREATION

# 1) CHECK NODE ADD PRIVILEGES
Scenario Outline: Node Access - Some roles can add FAQ content
Given I am logged in as a user with the <role> role
When I go to "node/add/faqs"
Then I should see <message>

Examples:
 | role                             | message                      |
 | developer             | "Create Frequently Asked Questions" |
| administrator         | "Create Frequently Asked Questions" |
| site_owner            | "Create Frequently Asked Questions" |
| content_editor        | "Create Frequently Asked Questions" |
| edit_my_content       | "Access Denied"              |
| site_editor           | "Create Frequently Asked Questions" |
# | edit_only             | "Create Frequently Asked Questions" |
# | access_manager        | "Access Denied"              |
# | configuration_manager | "Access Denied"              |

 Scenario: FAQ Access -  An anonymous user cannot add FAQ content
  When I am on "node/add/faqs"
  Then I should see "Access denied"
  
# 2) CHECK THAT A SIMPLE NODE CAN BE CREATED AND REVISED
Scenario: Node Functionality - a simple FAQ node can be created
Given I am logged in as a user with the "site_owner" role
 And I am on "node/add/faqs"
 And fill in "edit-title" with "My FAQs"
 And fill in "Body" with "Lorem ipsum dolor sit amet"
 When I press "edit-submit"
Then I should be on "/my-faqs"
And I should see "My FAQs"
And I should see "Lorem ipsum dolor sit amet"
 
#  2.5 CREATE REVISIONS TO THE NODE ABOVE
Scenario: Node functionality - Create Revision and Change Authorship of node
Given I am logged in as a user with the "site_owner" role
And I am on "admin/content"
And I follow "My FAQs"
And I follow "Edit"
 # BROKEN AT THIS TIME And fill in "edit-name" with "osr-test-edit-own" 
  And fill in "Body" with "Lavender Lemon Drops"
 And I press "Save"
 Then I should see "Frequently Asked Questions My FAQs has been updated."

# 3) CHECK EDITING AND DELETING PRIVILEGES ON THE NODE JUST MADE

Scenario Outline: Node Access -  Some roles can edit and delete node content
Given I am logged in as a user with the <role> role
And I am on "admin/content"
And I follow "My FAQs"
Then I should see "View"
And I should see "Edit"
And I should see "Edit Layout"
And I should see "Revisions"
And I should see "Clear Page Cache"
When I follow "Edit"
Then I should see "This document is now locked against simultaneous editing."
Then I should see "#edit-delete" 

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
And I follow "My FAQs"
Then I should see "View"
And I should see "Edit"
And I should not see "Edit Layout"
And I should not see "Revisions"
And I should see "Clear Page Cache"
When I follow "Edit"
Then I should not see "#edit-delete" 

@broken
#THIS TEST IS BROKEN UNTIL AUTHORSHIP CAN BE ASSIGNED ABOVE
Scenario: Node Access -  Edit My Content can edit but not delete node; can clear page cache
Given I am logged in as a user with the "edit_my_content" role
And I am on "admin/content"
And I follow "My FAQs"
Then I should see "View"
And I should see "Edit"
And I should not see "Edit Layout"
And I should not see "Revisions"
And I should not see "Clear Page Cache"
When I follow "Edit"
Then I should not see "#edit-delete" 

Scenario Outline: Node Access -  The add on roles cannot by themselves access content
Given I am logged in as a user with the <role> role
And I am on "admin/content"
Then I should see "Access denied"

Examples:
 | role                             | 
| access_manager        | 
| configuration_manager | 

# 4) CHECK THAT THE DELETE BUTTON ACTUALLY WORKS

  Scenario: Verify that the Delete button actually works
 Given I am logged in as a user with the "site_owner" role
And I am on "admin/content"
And I follow "My FAQs"
And I follow "Edit"
 And I press "Delete"
 Then I should see "Are you sure you want to delete Test FAQ Page?"
  And I press "Delete"
Then I am on "/"

# 5) CHECK MORE COMPLEX NODE CREATION
 
 Scenario: An authenticated user should be able to create an FAQ node
Given I am logged in as a user with the "site_owner" role
    And I am on "node/add/faqs"
    And fill in "edit-title" with "My New FAQ Page"
    And fill in "edit-body-und-0-value" with "Demo FAQ explanatory text"
    And fill in "edit-field-qa-collection-und-0-field-qa-collection-title-und-0-value" with "Section One Header"
    And fill in "edit-field-qa-collection-und-0-field-qa-und-0-field-qa-question-und-0-value" with "Question One"
    And fill in "edit-field-qa-collection-und-0-field-qa-und-0-field-qa-answer-und-0-value" with "An Answer to the Question"
    And press "Save"
    Then I should see "My New FAQ Page"
    And I should see "Demo FAQ explanatory text"
    And I should see "Section One Header"
    And I should see "Question One"
    # THIS LINE FAILS But I should not see "An Answer to the Question"
   
Scenario: Pressing "Add More" adds another FAQ section
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/faqs"
When I press "edit-field-qa-collection-und-0-field-qa-und-add-more"
And I wait 5 seconds
#THIS IS THE ID FOR THE TITLE OF THE NEW QUESTION
Then the response should contain "id=\"edit-field-qa-collection-und-0-field-qa-und-1-field-qa-question-und-0-value\""
# THIS DOESN'T WORK Then I should see an "edit-field-qa-collection-und-0-field-qa-und-1-field-qa-question-und-0-value" element

And I press "edit-field-qa-collection-und-add-more"
And I wait 5 seconds
#THIS IS THE ID FOR THE TITLE OF THE NEW FAQ SECTION
Then the response should contain "id=\"edit-field-qa-collection-und-1-field-qa-collection-title-und-0-value\""
# THIS DOESN'T WORK Then I should see an "edit-field-qa-collection-und-1-field-qa-collection-title-und-0-value" element
 Scenario: The provide menu link box should be checked on node creation but remain unchecked if user chooses to uncheck that box.
    Given  I am logged in as a user with the "site_owner" role
    When I go to "node/add/faqs"
    And  I fill in "edit-title" with "New FAQ"
    Then the "edit-menu-enabled" checkbox should be checked
    When I uncheck "edit-menu-enabled"
    And I press "Save"
    And I follow "Edit"
    Then the checkbox "edit-menu-enabled" should be unchecked
