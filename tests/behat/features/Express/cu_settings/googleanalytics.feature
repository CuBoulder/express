@settings
Feature: Google Analytics Account ID
In order to link my Web Express site with Google Analytics
An authenticated user with the proper role
Should be able to set the Google Analytics Account ID

#SOME ROLES CAN SET THE GOOGLE ANALYTICS ID

Scenario Outline: Devs, Admins and SOs can set the Google Analytics Account ID
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/site-configuration/google-analytics"
  When I fill in "edit-ga-account" with "UA-987654-1"
  And I press "Save"
  Then I should see "The configuration options have been saved"
  And I go to "admin/dashboard/seo"
  Then I should see "You have a custom google analytics account assigned to your website."
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

# SOME ROLES CAN NOT SET GOOGLE ANALYTICS ID

Scenario Outline: CEs and EMCs should not be able to set the Google Analytics Account ID
Given I am logged in as a user with the <role> role
And am on "admin/settings/site-configuration/google-analytics"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content | 
    


Scenario: An anonymous user should not be able to set the Google Analytics Account ID
  When I am on "admin/settings/site-configuration/google-analytics"
  Then I should see "Access denied"


Scenario Outline: Users cannot access the Google Analytics General Settings page
Given I am logged in as a user with the <role> role
And am on "admin/config/system/googleanalytics"
Then I should see "Access denied"

 Examples:
    | role            |
    | administrator   | 
    | site_owner      |
    | content_editor  | 
    | edit_my_content | 

