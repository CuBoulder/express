@api @people
Feature: Person Content Type
In order to create individual profiles
As an authenticated user
I should be able to create, edit, and delete a person node

Scenario Outline: An authenticated user should be able to access the form for adding person content
 Given  I am logged in as a user with the <role> role
 When I go to "node/add/person"
 Then I should see <message>

    Examples:
    | role            | message         |
    | edit_my_content | "Access denied" |
    | content_editor  | "Create Person" |
    | site_owner      | "Create Person" |
    | administrator   | "Create Person" |
    | developer       | "Create Person" |

Scenario: An anonymous user should not be able to access the form for adding person content
  When I am on "node/add/person"
  Then I should see "Access denied"

Scenario: A simple Person node can be created and deleted
 Given  I am logged in as a user with the "content_editor" role
 And am on "node/add/person"
 And fill in "First Name" with "Random"
 And fill in "Last Name" with "Individual"
 And I fill in "edit-field-person-photo-und-0-alt" with "Random Portrait"
And I attach the file "ralphie.jpg" to "edit-field-person-photo-und-0-upload"
When I press "Save"
Then I should see "Person Random Individual has been created."
And I follow "Edit"
And I press "edit-delete"
Then I should see "Are you sure you want to delete Random Individual?"
And I press "edit-submit"
Then I should see "Person Random Individual has been deleted."

@api 
 Scenario: Footer, Main Menu, and Secondary Menus should be available when creating a Person
  Given I am logged in as a user with the "content_editor" role
 And I am on "node/add/person"
 And I check "#edit-menu-enabled"
Then I select "<Footer Menu>" from "edit-menu-parent"
And I select "<Main Menu>" from "edit-menu-parent"
And I select "<Secondary Menu>" from "edit-menu-parent"
       
      
 @api @javascript 
Scenario: A Person node appears correctly in the mobile menu
 Given  I am logged in as a user with the "content_editor" role
   And I am on "node/add/person"
  And fill in "First Name" with "John"
      And fill in "Last Name" with "Doe"
        And I check "#edit-menu-enabled"
        And I select "<Secondary Menu>" from "edit-menu-parent"
        And I press "Save"
      Given I resize the window to a "mobile" resolution.
      When I click the ".mobile-menu-toggle a" element
      Then I should see "John Doe"
      And I resize the window to a "desktop" resolution.
      
      
      
 ## POPULATING DATA TABLE FOR PEOPLE LIST PAGES AND BLOCKS
 
 Scenario: Create Person 1 - Deshawn Michael 
  Given I am logged in as a user with the "content_editor" role
   And am on "node/add/person"
    And fill in "First Name" with "Deshawn"
    And fill in "Last Name" with "StaffGeo"
    And fill in "edit-field-person-job-type-und" with "Staff"
    And fill in "edit-field-person-title-und-0-value" with "Director"
    And fill in "edit-field-person-department-und" with "Geophysics"
    And fill in "edit-field-person-email-und-0-email" with "@example.com"
    And fill in "edit-field-person-phone-und-0-value" with "303-123-4567"
    And fill in "edit-field-person-filter-1-und" with ""
    And fill in "edit-field-person-filter-2-und" with ""
  When I press "Save"
  Then I should see "Person Deshawn Michael has been created."
  
   Scenario: Create Person 2 - Alejandro Cruz
  Given I am logged in as a user with the "content_editor" role
   And am on "node/add/person"
    And fill in "First Name" with "Alejandro"
    And fill in "Last Name" with "FacGeo"
    And fill in "edit-field-person-job-type-und" with "Faculty"
    And fill in "edit-field-person-title-und-0-value" with "Director"
    And fill in "edit-field-person-department-und" with "Geophysics"
    And fill in "edit-field-person-email-und-0-email" with "@example.com"
    And fill in "edit-field-person-phone-und-0-value" with "303-123-4567"
    And fill in "edit-field-person-filter-1-und" with ""
    And fill in "edit-field-person-filter-2-und" with ""
  When I press "Save"
  Then I should see "Person Alejandro Cruz has been created."
  
   Scenario: Create Person 3 - Kendall Hull
  Given I am logged in as a user with the "content_editor" role
   And am on "node/add/person"
    And fill in "First Name" with "Kendall"
    And fill in "Last Name" with "StaffTech"
    And fill in "edit-field-person-job-type-und" with "Staff"
    And fill in "edit-field-person-title-und-0-value" with "Supervisor"
    And fill in "edit-field-person-department-und" with "Technology"
    And fill in "edit-field-person-email-und-0-email" with "@example.com"
    And fill in "edit-field-person-phone-und-0-value" with "303-123-4567"
    And fill in "edit-field-person-filter-1-und" with ""
    And fill in "edit-field-person-filter-2-und" with ""
  When I press "Save"
  Then I should see "Person SKendall Hull has been created."
  
   Scenario: Create Person 4 - Abdullah Lang 
  Given I am logged in as a user with the "content_editor" role
   And am on "node/add/person"
    And fill in "First Name" with "Abdullah"
    And fill in "Last Name" with "FacTech"
    And fill in "edit-field-person-job-type-und" with "Faculty"
    And fill in "edit-field-person-title-und-0-value" with "Instructor"
    And fill in "edit-field-person-department-und" with "Technology"
    And fill in "edit-field-person-email-und-0-email" with "@example.com"
    And fill in "edit-field-person-phone-und-0-value" with "303-123-4567"
    And fill in "edit-field-person-filter-1-und" with ""
    And fill in "edit-field-person-filter-2-und" with ""
  When I press "Save"
  Then I should see "Person Abdullah Lang has been created."
  
  
  
  
Scenario: Content editors can create person nodes
  Given I am logged in as a user with the "content_editor" role
   And am on "node/add/person"
    And fill in "First Name" with "Staff"
    And fill in "Last Name" with "Person"
    And fill in "edit-field-person-job-type-und" with "Staff"
    And fill in "edit-field-person-title-und-0-value" with "My Job Title"
    And fill in "edit-field-person-department-und" with "Department One"
  When I press "Save"
  Then I should see "Person Staff Person has been created."

Scenario: Content editors can create person nodes
  Given I am logged in as a user with the "content_editor" role
    And am on "node/add/person"
    And fill in "First Name" with "Faculty"
    And fill in "Last Name" with "Person"
    And fill in "edit-field-person-job-type-und" with "Faculty"
    And fill in "edit-field-person-title-und-0-value" with "My Job Title"
      And fill in "edit-field-person-department-und" with "Department Two"
  When I press "Save"
  Then I should see "Person Faculty Person has been created."

  # Given I am logged in as a user with the "content_editor" role
    And am on "node/add/people-list-page"
    And fill in "Title" with "People"
    And I select "Table" from "edit-field-people-list-display-und"
    And I select "Grid" from "edit-field-people-list-display-und"
    And I select "List" from "edit-field-people-list-display-und"
    And I select "Show" from "edit-field-people-pos-filter-show-und"
  When I press "Save"
    And I go to "people"
  Then I should see "Staff Person"
    And I should see "Faculty Person"
    And I should see a "select" element

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

  @api @people @people-filters
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

  
      

  @api @people @people-filters
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
