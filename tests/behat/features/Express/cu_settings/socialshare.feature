@settings
Feature: Social Share Settings encourage your site's visitors to share your site's content through social media
In order to place social media links on node types
An authenticated user with the proper role
Should be able to set Social Share options

#CREATE A BASIC PAGE TO TEST SOCIAL SHARE LINKS
Scenario: Creating a page for the following tests
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
When I fill in "edit-title" with "MyPage"
And I fill in "Body" with "Amazingly interesting information"
And I press "Save"
Then I should see "Amazingly interesting information"

#SOME ROLES CAN ACCESS THE SOCIAL SHARE SETTINGS
@api
Scenario Outline: Devs, Admins and SOs can set the Social Sharing options
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/social/share"
  And I check "edit-cu-share-settings-twitter-enabled"
  And I check "edit-cu-share-settings-facebook-enabled"
  And I select "side_bottom" from "cu_share_position"
  And I check "edit-basic-settings-page"
  And I click "edit-submit"
  And I go to "mypage"
  Then the response should contain "class=\"cu-share-sidebar\""
  And I should see a "div" element with the "class" attribute set to "cu-share-sidebar"
    
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
