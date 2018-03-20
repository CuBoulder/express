@settings
Feature: Social Share Settings encourage your site's visitors to share your site's content through social media
In order to place social media links on node types
An authenticated user with the proper role
Should be able to select a published form

#SOME ROLES CAN ACCESS THE SOCIAL SHARE SETTINGS
@api
Scenario Outline: Devs, Admins and SOs can set the Social Sharing options
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/social/share"
  And I click "edit-cu-share-settings-facebook-enabled"
  And I click "edit-cu-share-position-side-bottom"
  And I click "edit-basic-settings-page"
  Then stuff should happen
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

# SOME ROLES CAN NOT ACCESS THE SOCIAL SHARE SETTINGS
@api 
Scenario Outline: CEs and EMCs should not be able to set the Social Sharing options
Given I am logged in as a user with the <role> role
And am on "admin/settings/social/share"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
