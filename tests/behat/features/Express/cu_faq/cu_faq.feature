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
  Scenario: An authenticated user should be able to create a basic page node
    Given I am logged in as a user with the <role> role
      And I am on "node/add/faqs"
      And fill in "Title" with "FAQs"
      And fill in "Body" with "Demo FAQ Content"
       And fill in "edit-field-qa-collection-und-0-field-qa-collection-title-und-0-value" with "Section One"
     And fill in "edit-field-qa-collection-und-0-field-qa-und-0-field-qa-question-und-0-value" with "Question One"
     And fill in "cke_edit-field-qa-collection-und-0-field-qa-und-0-field-qa-answer-und-0-value" with "Answer One"
And press "Save"
Then I should see "FAQs"
And I should see "Section One"
And I should see "#cu_faq-entity_view_1-0"
  
      
 Examples:
    | role            | 
    | content_editor  | 
    | site_owner      | 
    | administrator   | 
    | developer       | 
    

  @api 
  Scenario Outline: The provide menu link box should be checked on node creation but remain unchecked if user chooses to uncheck that box.
    Given  I am logged in as a user with the "site_owner" role
    When I go to "node/add/faqs"
    And  I fill in "edit-title" with "New FAQ"
    Then the "edit-menu-enabled" checkbox should be checked
    When I uncheck "edit-menu-enabled"
    And I press "Save"
   And I follow "Edit"
   Then the checkbox "edit-menu-enabled" should be unchecked
