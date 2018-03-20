@settings
Feature: Enabling Bundles
In order to add functionality to a Web Express site
An authenticated user with the proper role
Should be able to access the Bundle List pages

#SOME ROLES CAN ENABLE BUNDLES
@api
Scenario: Devs, Admins and SOs can access the Bundle List page and see three tabs
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/bundles/list"
  Then I should see "Configure Bundles"
  And I should see "Core"
  And I should see "Add-on"
  And I should see "Request"
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 


# SOME ROLES CAN NOT ENABLE BUNDLES
@api 
Scenario Outline: CEs and EMCs should not be able to access the Bundle List page
Given I am logged in as a user with the <role> role
And am on "admin/settings/bundles/list"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
   
 @api 
Scenario Outline: CEs and EMCs should not be able to access the Bundle Add-on page
Given I am logged in as a user with the <role> role
And am on "admin/settings/bundles/list/addon"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
    
 @api 
Scenario Outline: CEs and EMCs should not be able to access the Bundle Requeset page
Given I am logged in as a user with the <role> role
And am on "admin/settings/bundles/list/request"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
