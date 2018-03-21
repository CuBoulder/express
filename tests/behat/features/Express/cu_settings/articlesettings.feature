@settings
Feature: Article Settings allow the user to hide/show an article's published date
In order to show or hide an article's published date
An authenticated user with the proper role
Should be able to set Article Settings options

#CREATE AN ARTICLE NODE TO TEST ARTICLE SETTINGS OPTIONS
Scenario: Creating an article node for the following tests
And I am on "node/add/article"
And fill in "Title" with "MyArticle"
And fill in "Body" with "This happened lately."
And I press "Save"
Then I should see "This happened lately."
And the response should contain "class=\"author-meta-data\""
And I should see a "span" element with the "class" attribute set to "author-meta-data"

#SOME ROLES CAN ACCESS THE ARTICLE SETTINGS OPTIONS
@api
Scenario Outline: Devs, Admins and SOs can set the Article Settings options
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/news/article-settings"
  And I check "edit-cu-share-settings-twitter-enabled"
  And I check "edit-cu-share-settings-facebook-enabled"
  And I check "edit-cu-share-position-side-bottom"
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

# SOME ROLES CAN NOT ACCESS THE ARTICLE SETTINGS OPTIONS
@api 
Scenario Outline: CEs and EMCs should not be able to set the Article Settings options
Given I am logged in as a user with the <role> role
And am on "admin/settings/news/article-settings"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
