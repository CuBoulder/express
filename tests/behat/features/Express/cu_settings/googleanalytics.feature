@settings
Feature: Google Analytics Account ID
In order to link my Web Express site with Google Analytics
An authenticated user with the proper role
Should be able to set the Google Analytics Account ID

#SOME ROLES CAN SET THE GOOGLE ANALYTICS ID
@api
Scenario Outline: Devs, Admins, SOs and ConMgrs can set the Google Analytics Account ID
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
    | configuration_manager |

# SOME ROLES CAN NOT SET GOOGLE ANALYTICS ID
@api 
Scenario Outline: Most roles cannot set the Google Analytics Account ID
Given I am logged in as a user with the <role> role
And am on "admin/settings/site-configuration/google-analytics"
Then I should see "Access denied"

Examples
| role |
| content_editor |
| edit_my_content  | 
| site_editor      | 
| edit_only        | 
| access_manager   | 
    
@api 
Scenario: An anonymous user should not be able to set the Google Analytics Account ID
  When I am on "admin/settings/site-configuration/google-analytics"
  Then I should see "Access denied"

@api
Scenario Outline: Users cannot access the Google Analytics General Settings page
Given I am logged in as a user with the <role> role
And am on "admin/config/system/googleanalytics"
Then I should see "Access denied"

 Examples:
    | role            |
    | administrator   | 
    | site_owner      |
    | content_editor |
    | edit_my_content  | 
    | site_editor      | 
    | edit_only        | 
    | access_manager   | 

