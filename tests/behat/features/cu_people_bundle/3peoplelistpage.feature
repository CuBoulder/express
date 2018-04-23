@api @people
Feature: People List Page Content Type
In order to display a directory list of Person nodes
As an authenticated user
I should be able to create, edit, and delete People List Page content

@api 
Scenario Outline: An authenticated user should be able to access the form for adding people list page content
    Given  I am logged in as a user with the <role> role
    When I go to "node/add/people-list-page"
    Then I should see <message>

    Examples:
    | role            | message         |
    | edit_my_content | "Access denied" |
    | content_editor  | "Create People List Page" |
    | site_owner      | "Create People List Page" |
    | administrator   | "Create People List Page" |
    | developer       | "Create People List Page" |

@api 
Scenario: An anonymous user should not be able to access the form for adding people list page content
  When I am on "node/add/people-list-page"
  Then I should see "Access denied"

 @api
  Scenario: The provide menu link box should be checked on node creation but remain unchecked if user chooses to uncheck that box.
    Given I am logged in as a user with the "site_owner" role
    When I go to "node/add/people-list-page"
    And  I fill in "Title" with "New People List Page"
    Then the "edit-menu-enabled" checkbox should be checked
    When I uncheck "edit-menu-enabled"
    And I press "Save"
    And I follow "Edit"
   Then the checkbox "edit-menu-enabled" should be unchecked
   
@api @javascript
 Scenario: The People List Page provides several display/format types
    Given I am logged in as a user with the "site_owner" role
    And am on "node/add/people-list-page"
    And I select "Table" from "edit-field-people-list-display-und"
    And I select "Grid" from "edit-field-people-list-display-und"
    And I select "List" from "edit-field-people-list-display-und"

@api @javascript
 Scenario: The People List Page provides several display/format types
    Given I am logged in as a user with the "site_owner" role
    And am on "node/add/people-list-page"
    And I click ".group-people-list-display a.fieldset-title"
    And I select "Table" from "edit-field-people-list-display-und"
    And I select "Grid" from "edit-field-people-list-display-und"
    And I select "List" from "edit-field-people-list-display-und"   
     
@api @javascript
 Scenario: The People List Page has been populated with Filters
    Given I am logged in as a user with the "site_owner" role
    And am on "node/add/people-list-page"
    And I click ".group-people-list-display a.fieldset-title"
    And I select "Table" from "edit-field-people-list-display-und"
    And I select "Grid" from "edit-field-people-list-display-und"
    And I select "List" from "edit-field-people-list-display-und"   

  # Given  I am logged in as a user with the "content_editor" role
    And am on "node/add/people-list-page"
    And fill in "Title" with "Faculty People"
    And I check "Faculty"
  When I press "Save"
    And I go to "faculty-people"
  Then I should not see "Staff Person"
    And I should see "Faculty Person"

  # Given  I am logged in as a user with the "content_editor" role
    And am on "node/add/people-list-page"
    And fill in "Title" with "Staff People"
    And I check "Staff"
  When I press "Save"
    And I go to "staff-people"
  Then I should see "Staff Person"
    And I should not see "Faculty Person"

  # Given  I am logged in as a user with the "content_editor" role
    And am on "node/add/people-list-page"
    And fill in "Title" with "Department One People"
    And I check "Department One"
  When I press "Save"
    And I go to "department-one-people"
  Then I should see "Staff Person"
    And I should not see "Faculty Person"

  # Given  I am logged in as a user with the "content_editor" role
    And am on "node/add/people-list-page"
    And fill in "Title" with "Department Two People"
    And I check "Department Two"
  When I press "Save"
    And I go to "department-two-people"
  Then I should not see "Staff Person"
    And I should see "Faculty Person"

  @api
  Scenario: Person nodes should accept more than 1 filter value per filter
    Given  I am logged in as a user with the "content_editor" role
      And am on "node/add/person"
      And fill in "First Name" with "Faculty"
      And fill in "Last Name" with "Person"
      And fill in "edit-field-person-filter-1-und" with "Filter 1 Term 1, Filter 1 Term 2"
      And fill in "edit-field-person-filter-2-und" with "Filter 2 Term 1, Filter 2 Term 2"
      And fill in "edit-field-person-filter-3-und" with "Filter 3 Term 1, Filter 3 Term 2"
    When I press "Save"
    Given I go to "admin/structure/taxonomy/people_filter_1"
    Then I should see "Filter 1 Term 1"
      And I should see "Filter 1 Term 2"
      And I should not see "Filter 1 Term 1, Filter 1 Term 2"
    Given I go to "admin/structure/taxonomy/people_filter_2"
    Then I should see "Filter 2 Term 1"
      And I should see "Filter 2 Term 2"
      And I should not see "Filter 2 Term 1, Filter 2 Term 2"
    Given I go to "admin/structure/taxonomy/people_filter_3"
    Then I should see "Filter 3 Term 1"
      And I should see "Filter 3 Term 2"
      And I should not see "Filter 3 Term 1, Filter 3 Term 2"

 @api
  Scenario: Adding a label to the filter terms should result in the label showing up on the people list page.
    Given  I am logged in as a user with the "site_owner" role
      And am on "node/add/person"
      And fill in "First Name" with "Staff"
      And fill in "Last Name" with "Person"
      And fill in "Job Type" with "Staff"
      And fill in "edit-field-person-title-und-0-value" with "My Job Title"
      And fill in "Department" with "Department One"
      And fill in "edit-field-person-filter-1-und" with "apples"
      And fill in "edit-field-person-filter-2-und" with "cats"
      And fill in "edit-field-person-filter-3-und" with "trees"
    When I press "Save"
      And am on "node/add/person"
      And fill in "First Name" with "Faculty"
      And fill in "Last Name" with "Person"
      And fill in "Job Type" with "Faculty"
      And fill in "edit-field-person-title-und-0-value" with "My Job Title"
      And fill in "Department" with "Department Two"
      And fill in "edit-field-person-filter-1-und" with "oranges"
      And fill in "edit-field-person-filter-2-und" with "dogs"
      And fill in "edit-field-person-filter-3-und" with "shrubs"
    When I press "Save"
      And am on "admin/settings/people/settings"
      And I fill in "Department Label" with "Group"
      And I fill in "Type Label" with "type 2"
      And I fill in "Filter One Label" with "filter one label"
      And I fill in "Filter Two Label" with "filter two label"
      And I fill in "Filter Three Label" with "filter three label"
      And I press "Save"
      And I am on "node/add/people-list-page"
      And I fill in "Title" with "People List Page"
      And I select "Show" from "edit-field-people-dept-filter-show-und"
      And I select "Show" from "edit-field-people-pos-filter-show-und"
      And I select "Show" from "edit-field-people-filter1-show-und"
      And I select "Show" from "edit-field-people-filter2-show-und"
      And I select "Show" from "edit-field-people-filter3-show-und"
      And I press "Save"
    Then I should see "Group"
      And I should see "type 2"
      And I should see "filter one label"
      And I should see "filter two label"
      And I should see "filter three label"
