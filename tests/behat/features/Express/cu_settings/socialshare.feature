@settings
Feature: Social Share Settings encourage your site's visitors to share your site's content through social media
In order to place social media links on node types
An authenticated user with the proper role
Should be able to set Social Share options

#ACCESSING THE SOCIAL SHARE PAGE
@api
Scenario Outline: Devs, Admins and SOs can access the Social Share page; CEs and EMCs cannot
  Given I am logged in as a user with the <role> role
  When I go to "admin/settings/social/share"
  Then I should see <message>

 Examples:
    | role            | message |
    | developer       | "Choose the order and which social media links to display" |
    | administrator   | "Choose the order and which social media links to display" |
    | site_owner      | "Choose the order and which social media links to display" |
    | content_editor  | "Access Denied" |
    | edit_my_content | "Access Denied" |
    

# SETTING THE SOCIAL SHARE LINKS
Scenario: A Site Owner can set the social share links and verify that they appear on the specified nodes
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  When I fill in "edit-title" with "MyPage"
  And I fill in "Body" with "Amazingly interesting information"
  And I press "Save"
  Then I should see "Amazingly interesting information"
  Then I go to "admin/settings/social/share"
  And I check "edit-cu-share-settings-twitter-enabled"
  And I check "edit-cu-share-settings-facebook-enabled"
  And I select "side_bottom" from "cu_share_position"
  And I check "edit-basic-settings-page"
  And I click "edit-submit"
  And I go to "mypage"
  Then the response should contain "class=\"cu-share-sidebar\""
  And I should see a "div" element with the "class" attribute set to "cu-share-sidebar"
