@settings
Feature: Google Analytics Account ID
In order to link my Web Express site with Google Analytics
An authenticated user with the proper role
Should be able to set the Google Analytics Account ID

#SOME ROLES CAN SET THE SITE NAME
@api
Scenario: Devs, Admins and SOs can set the Google Analytics Account ID
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/site-configuration/google-analytics"
  And fill in "edit-ga-account" with "UA-987654-1"
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
Scenario Outline: CEs and EMCs should not be able to set the Google Analytics Account ID
Given I am logged in as a user with the <role> role
And am on "admin/settings/site-configuration/google-analytics"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
