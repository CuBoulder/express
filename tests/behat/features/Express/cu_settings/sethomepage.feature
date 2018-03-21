@rebuild
Feature: Setting a New Homepage
In order to create a unique homepage experience
An authenticated user with the proper role
Should be able to change the default front page

#CREATE A BASIC PAGE TO TEST HOME PAGE SETTING
Scenario: Creating a page for the following tests
And I am on "node/add/page"
And fill in "edit-title" with "New Home"
And fill in "Body" with "Our special new home page"
And I uncheck "edit-menu-enabled"
And I press "Save"
Then the url should match "new-home"

#SOME ROLES CAN SET THE ERROR PAGES
@api
Scenario Outline: Devs, Admins and SOs can access and change the Set Homepage settings
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/adv-content/frontpage"
  And fill in "edit-site-frontpage" with "new-home"
  When I press "Save"
  Then I should see "Please enter a valid path."
  And I go to "/"
  Then I should see "Our special new home page"
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

# SOME ROLES CAN NOT SET THE ERROR PAGES
@api 
Scenario Outline: CEs and EMCs should not access the Set Homepage settings
Given I am logged in as a user with the <role> role
And am on "admin/settings/adv-content/frontpage"
Then I should see "Access Denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
