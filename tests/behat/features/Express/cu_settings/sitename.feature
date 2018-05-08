@settings
Feature: Site Name identifies the Web Express website; appears in top banner
In order to identify what Web Express site this is
An authenticated user with the proper role
Should be able to set the website name

#SOME ROLES CAN SET THE SITE NAME
 @testing_frontpage
Scenario Outline: Devs, Admins and SOs can set the Site Name
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/site-configuration/site-name"
  And fill in "edit-site-name-1" with "New Site Title"
  And fill in "edit-site-name-2" with "Second Line"
  When I press "Save"
  Then I should see "The configuration options have been saved"
  And I go to "/"
  Then I should see a ".site-name-two-lines" element
  And I should see "New Site Title Second Line"
  
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

# SOME ROLES CAN NOT SET SITE NAME

Scenario Outline: CEs and EMCs should not be able to set site name
Given I am logged in as a user with the <role> role
And am on "admin/settings/site-configuration/site-name"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 


Scenario: An anonymous user should not be able to set site name
 When I am on "admin/settings/site-configuration/site-name"
 Then I should see "Access denied"
