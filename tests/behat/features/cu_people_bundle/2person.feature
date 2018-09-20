@people
Feature: Person Content Type
  In order to create individual profiles
  As an authenticated user
  I should be able to create, edit, and delete a person node

  Scenario Outline: An authenticated user should be able to access the form for adding person content
    Given I am logged in as a user with the <role> role
    When I go to "node/add/person"
    Then I should see <message>

    Examples:
      | role                  | message         |
      | edit_my_content       | "Access denied" |
      | content_editor        | "Create Person" |
      | site_owner            | "Create Person" |
      | administrator         | "Create Person" |
      | developer             | "Create Person" |
      | configuration_manager | "Access denied" |
      | site_editor           | "Create Person" |
      | edit_only             | "Access denied" |
      | access_manager        | "Access denied" |

  Scenario: An anonymous user should not be able to access the form for adding person content
    When I am on "node/add/person"
    Then I should see "Access denied"

# Create a person node to test editing access
  Scenario: A simple Person node can be created
    Given I am logged in as a user with the "site_owner" role
    And am on "node/add/person"
    And fill in "First Name" with "Random"
    And fill in "Last Name" with "Individual"
    And I fill in "edit-field-person-photo-und-0-alt" with "Random Portrait"
    And I attach the file "ralphie.jpg" to "edit-field-person-photo-und-0-upload"
    When I press "Save"
    Then I should see "Person Random Individual has been created."
    
   Scenario: A user with the Edit Only role can edit but not delete Person nodes
    Given I am logged in as a user with the "edit_only" role 
    And am on "random-individual"
    And I follow "Edit"
    Then I should see "This document is now locked against simultaneous editing."
    But I should not see "Delete"

  Scenario: Footer, Main Menu, and Secondary Menus should be available when creating a Person
    Given I am logged in as a user with the "content_editor" role
    And I am on "node/add/person"
    And I check "Provide a menu link"
    Then I select "<Footer Menu>" from "edit-menu-parent"
    And I select "<Main menu>" from "edit-menu-parent"
    And I select "<Secondary Menu>" from "edit-menu-parent"

  @javascript @broken
  Scenario: A Person node appears correctly in the mobile menu
    Given I am logged in as a user with the "site_owner" role
    And I am on "node/add/person"
    And fill in "First Name" with "John"
    And fill in "Last Name" with "Doe"
    And I check "edit-menu-enabled"
    And I select "<Secondary Menu>" from "edit-menu-parent"
    And I press "Save"
    Given I resize the window to a "mobile" resolution.
    # DOESN'T LIKE THIS LINE When I click the ".mobile-menu-toggle a" element.
    Then I should see "John Doe"
    And I resize the window to "desktop" resolution.

 Scenario: Person nodes can accept more than one filter value per filter
   Given I am logged in as a user with the "site_owner" role
    And am on "node/add/person"
    And fill in "First Name" with "Misc"
    And fill in "Last Name" with "Ellaneous"
    And fill in "edit-field-person-filter-1-und" with "Apple, Orange"
    And fill in "edit-field-person-filter-2-und" with "Cat, Dog"
    And fill in "edit-field-person-filter-3-und" with "Green, Red"
    When I press "Save"
    Given I go to "admin/structure/taxonomy/people_filter_1"
    Then I should see "Apple"
    And I should see "Orange"
    And I should not see "Apple, Orange"
    Given I go to "admin/structure/taxonomy/people_filter_2"
    Then I should see "Cat"
    And I should see "Dog"
    And I should not see "Cat, Dog"
    Given I go to "admin/structure/taxonomy/people_filter_3"
    Then I should see "Green"
    And I should see "Red"
    And I should not see "Green, Red"
