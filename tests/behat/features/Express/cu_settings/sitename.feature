@settings
Feature: Site Name
In order to identify what WEb Express site this is
An authenticated user with the proper role
Should be able to set the site name

#SOME ROLES CAN SET THE SITE NAME
@api
Scenario: Devs, Admins and SOs can set the Site Name
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/site-configuration/site-name"
  And fill in "edit-site-name-1" with "New Site Title"
  And fill in "edit-site-name-2" with "Second Line"
  When I press "Save"
  Then I should see "The configuration options have been saved"
  And I go to "/"
  Then I should see "New Site Title Second Line"
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

# SOME ROLES CAN NOT SET SITE NAME
@api 
Scenario Outline: CEs and EMCs should not be able to set site name
Given I am logged in as a user with the <role> role
And am on admin/settings/site-configuration/site-name
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
