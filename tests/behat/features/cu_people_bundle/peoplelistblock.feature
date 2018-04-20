@people
Feature: People List Block
In order to place lists of people on different types of node
As an authenticated user
I should be able to create a People List block

@api
Scenario Outline: An authenticated user can access the form for adding a people list block
    Given I am logged in as a user with the <role> role
    When I go to "block/add/people-list-block"
    Then I should see <message>

    Examples:
    | role           | message         |
    | edit_my_content | "Access denied" |
    | content_editor | "Create People List Block block" |
    | site_owner     | "Create People List Block block" |
    | administrator  | "Create People List Block block" |
    | developer      | "Create People List Block block" |

@api 
Scenario: An anonymous user cannot access the form for adding person content
 When I am on "block/add/people-list-block"
 Then I should see "Access denied"
  
 @api 
Scenario: A simple People List Block offers several display views
  Given I am logged in as a user with the "content_editor" role
  And am on "block/add/people-list-block"
  When I select <condition> from "edit-field-people-block-thumbnail-und"

  Examples:
    | condition |
    | "teaser" |
    | "grid" |
    | "sidebar" |
    | "title" |
   
 @api 
Scenario: A simple People List Block can be created; offers several display views
 Given I am logged in as a user with the "content_editor" role
 And am on "block/add/people-list-block"
 And fill in "edit-label" with "Simple People Block Label"
 And fill in "edit-title" with "Simple People Block Title"
 When I press "Save"
Then I should see "People List Block My People has been created."
And I am on "block/my-people/view"
  


@api 
Scenario: Content editors can create person nodes
  Given I am logged in as a user with the "content_editor" role
    And am on "node/add/person"
    And fill in "First Name" with "Staff"
    And fill in "Last Name" with "Person"
    And fill in "Job Type" with "Staff"
    And fill in "edit-field-person-title-und-0-value" with "My Job Title"
    And fill in "Department" with "Department One"
  When I press "Save"
  Then I should see "Person Staff Person has been created."

  # Given I am logged in as a user with the "content_editor" role
    And am on "node/add/person"
    And fill in "First Name" with "Faculty"
    And fill in "Last Name" with "Person"
    And fill in "Job Type" with "Faculty"
    And fill in "edit-field-person-title-und-0-value" with "My Job Title"
    And fill in "Department" with "Department Two"
  When I press "Save"
  Then I should see "Person Faculty Person has been created."

  # Given I am logged in as a user with the "content_editor" role
    And am on "block/add/people-list-block"
    And fill in "Title" with "People List Block"
    And fill in "Label" with "People List Block"
  When I press "Save"
  Then I should see "Staff Person"
    And I should see "Faculty Person"
