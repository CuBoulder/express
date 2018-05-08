@settings
#NOTE: THIS FEATURE NEEDS A GA ACCOUNT FOR ADVANCED FUNCTIONALITY; HENCE THE SIMPLE TESTS BELOW
Feature: Site Search Settings
In order to improve search capabilities
An authenticated user with the proper role
Should be able to access the Site Search Settings

#SOME ROLES CAN SET THE SITE SEARCH SETTINGS

Scenario Outline: Devs, Admins and SOs can set the Site Search Settings
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/search/search-settings"
  Then I should see "Select the options for the site search box"
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

# SOME ROLES CAN NOT SET THE SITE SEARCH SETTINGS

Scenario Outline: CEs and EMCs should not be able to set Site Search Settings
Given I am logged in as a user with the <role> role
And am on "admin/settings/search/search-settings"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 


Scenario: An anonymous user should not be able to set Site Search Settings
 When I am on "admin/settings/search/search-settings"
 Then I should see "Access denied"
  
