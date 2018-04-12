@settings
Feature: People Filter Labels
In order to further categorize Persons
An authenticated user with the proper role
Should be able to change the labels of the People Filters

#SOME ROLES CAN CHANGE THE PEOPLE FILTER LABELS
@api
Scenario Outline: Devs, Admins and SOs can change the People Filter Labels
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/people/settings"
  And fill in "edit-department-label" with "Office"
  And fill in "edit-type-label" with "Assignment"
  And fill in "edit-filter-one-label" with "Team"
  And fill in "edit-filter-two-label" with "Research Area"
  And fill in "edit-filter-three-label" with "Class"
  And I press "Save"
  Then I should see "Settings have been saved"
  And I go to "node/add/person"
  Then I should see "Job Type/Assignment"
  And I should see "Department/Office"
  And I should see "Filter 1/Team"
  And I should see "Filter 2/Research Area"
  And I should see "Filter 3/Class"
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

# SOME ROLES CAN NOT CHANGE THE PEOPLE FILTER LABELS
@api 
Scenario Outline: CEs and EMCs should not be access the People Filter Labels
Given I am logged in as a user with the <role> role
And am on "admin/settings/people/settings"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
    
@api 
Scenario: An anonymous user should not be able to  access the People Filter Labels
  When I am on "admin/settings/people/settings"
  Then I should see "Access denied"
