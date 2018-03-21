@settings
Feature: Error Pages
In order to improve a reader's experience with missing Web Express pages
An authenticated user with the proper role
Should be able to set unique 404 and 403 pages

#CREATE A BASIC PAGE TO TEST ERROR PAGE SETTING
Scenario: Creating a page for the following tests
And I am on "node/add/page"
And fill in "Title" with "Bad Page"
And fill in "Body" with "The requested page is not available"
And I uncheck "edit-menu-enabled"
And I press "Save"
Then the url should match "bad-page"

#SOME ROLES CAN SET THE ERROR PAGES
@api
Scenario Outline: Devs, Admins and SOs can access and set Error Pages
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/adv-content/error"
  And fill in "edit-site-404" with "bad-page"
  When I press "Save"
  Then I should see "The configuration options have been saved"
  And I go to "test-404-page"
  Then I should see "Bad Page"
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

# SOME ROLES CAN NOT SET THE ERROR PAGES
@api 
Scenario Outline: CEs and EMCs should not access the Error Pages settings
Given I am logged in as a user with the <role> role
And am on "admin/settings/adv-content/error"
Then I should see "Access Denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
