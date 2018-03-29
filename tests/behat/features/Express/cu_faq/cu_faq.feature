@faqs
Feature: Frequently Asked Questions Content Type
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete FAQ content
  
Scenario Outline: An authenticated user should be able to access the form for adding FAQ content
Given I am logged in as a user with the <role> role
When I go to "node/add/faqs"
 Then I should see <message>

    Examples:
      | role            | message                      |
      | edit_my_content | "Access Denied"              |
      | content_editor  | "Frequently Asked Questions" |
      | site_owner      | "Frequently Asked Questions" |
      | administrator   | "Frequently Asked Questions" |
      | developer       | "Frequently Asked Questions" |

 Scenario: An anonymous user should not be able to access the form for adding FAQ content
   When I am on "node/add/faqs"
   Then I should see "Access denied"
 
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
    But I should not see "An Answer to the Question"
    # And when I press "Question One"
    # And I wait for AJAX
    # Then I should see "An Answer to the Question"
   # When I click the "ui-accordion-1-header-0" element
   # Then I should see "An Answer to the Question"

Scenario: A user can add more Q&A sections, and more collection sections
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/faqs"
When I press "edit-field-qa-collection-und-0-field-qa-und-add-more"
And I wait 5 seconds
Then I should see "#edit-field-qa-collection-und-0-field-qa-und-1-field-qa-question-und-0-value"
And I press "edit-field-qa-collection-und-add-more"
And I wait 5 seconds
Then I should see "#edit-field-qa-collection-und-1-field-qa-collection-title-und-0-value"

  Scenario: The provide menu link box should be checked on node creation but remain unchecked if user chooses to uncheck that box.
    Given  I am logged in as a user with the "site_owner" role
    When I go to "node/add/faqs"
    And  I fill in "edit-title" with "New FAQ"
    Then the "edit-menu-enabled" checkbox should be checked
    When I uncheck "edit-menu-enabled"
    And I press "Save"
    And I follow "Edit"
    Then the checkbox "edit-menu-enabled" should be unchecked

  Scenario Outline: An authenticated user can delete an FAQ node
    Given I am logged in as a user with the <role> role
    When I go to "node/add/faqs"
    And  I fill in "edit-title" with "Test FAQ Page"
    And fill in "Body" with "Do not keep this page"
    And I press "Save"
    And I follow "Edit"
    And I press "Delete"
    Then I should see "Are you sure you want to delete Test FAQ Page?"
    And I press "Delete"
    Then I am on "/"

    Examples:
      | role           |
      | content_editor |
      | site_owner     |
      | administrator  |
      | developer      | 
