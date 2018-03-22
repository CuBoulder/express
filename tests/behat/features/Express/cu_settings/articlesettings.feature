@settings
Feature: Article Settings allow the user to hide/show an article's published date
In order to show or hide an article's published date
An authenticated user with the proper role
Should be able to set Article Settings options

#SOME ROLES CAN ACCESS THE ARTICLE SETTINGS OPTIONS
@api
Scenario Outline: Devs, Admins and SOs can access the Article Settings options
  Given I am logged in as a user with the <role> role
  When I go to "admin/settings/news/article-settings"
 Then I should see "Article Published Date Display"
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

#CHANGING THE SETTINGS HIDES THE PUBLISHED DATE ON ARTICLE
@api
Scenario Outline: Devs, Admins and SOs can change the Article Settings; aka hide publish date on article
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/news/article-settings"
  When I select "hide" from "date_display"
  And I click "edit-submit"
 Then I should see "Article settings have been saved."
And I go to "node/add/article"
And I fill in "edit-title" with "A New Article"
And I fill in "Body" with "Here is more information."
And I press "Save"
Then I should see "Here is more information."
# DOESN'T WORK And the response should contain "class=\"author-meta-data\""
And I should not see a "span" element with the "class" attribute set to "author-meta-data"
    
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
