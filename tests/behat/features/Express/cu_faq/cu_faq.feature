@faqs
Feature: Frequently Asked Questions Content Type
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete FAQ content
  
@api
Scenario Outline: An authenticated user should be able to access the form for adding faq content
 Given  I am logged in as a user with the <role> role
 When I go to "node/add/faqs"
 Then I should see <message>

 Examples:
    | role            | message                      |
    | edit_my_content | "Access Denied"              |
    | content_editor  | "Frequently Asked Questions" |
    | site_owner      | "Frequently Asked Questions" |
    | administrator   | "Frequently Asked Questions" |
    | developer       | "Frequently Asked Questions" |

@api 
Scenario: An anonymous user should not be able to access the form for adding page content
  When I am on "node/add/faqs"
  Then I should see "Access denied"
    
@api 
Scenario Outline: An authenticated user should be able to create a basic page node
  Given I am logged in as a user with the <role> role
  And I am on "node/add/faqs"
  And fill in "edit-title" with "My New FAQ Page"
  # And fill in "Body" with "Demo FAQ explanatory text"
  And fill in "edit-body-und-0-value" with "Demo FAQ explanatory text"
  And fill in "edit-field-qa-collection-und-0-field-qa-collection-title-und-0-value" with "Section One Header"
  And fill in "edit-field-qa-collection-und-0-field-qa-und-0-field-qa-question-und-0-value" with "Question One"
  And fill in "edit-field-qa-collection-und-0-field-qa-und-0-field-qa-answer-und-0-value" with "An Answer to the Question"
  And press "Save"
  Then I should see "My New FAQ Page"
  And I should see "Demo FAQ explanatory text"
  And I should see "Section One Header"
  And I should see "Question One"
  When I click the "ui-accordion-1-header-0" element
  Then I should see "An Answer to the Question"
  
 Examples:
    | role            | 
    | content_editor  | 
    | site_owner      | 
    | administrator   | 
    | developer       | 
    

@api 
Scenario: The provide menu link box should be checked on node creation but remain unchecked if user chooses to uncheck that box.
  Given  I am logged in as a user with the "site_owner" role
  When I go to "node/add/faqs"
  And  I fill in "edit-title" with "New FAQ"
  Then the "edit-menu-enabled" checkbox should be checked
  When I uncheck "edit-menu-enabled"
  And I press "Save"
  And I follow "Edit"
  Then the checkbox "edit-menu-enabled" should be unchecked
