@settings
Feature: Article Settings allow the user to hide/show an article's published date
In order to show or hide an article's published date
An authenticated user with the proper role
Should be able to set Article Settings options

#CREATE AN ARTICLE NODE TO TEST ARTICLE SETTINGS OPTIONS
Scenario: Creating an article node for the following tests
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/article"
When I fill in "edit-title" with "MyArticle"
And I fill in "Body" with "We have lots going on around here."
And I press "Save"
Then I should see "We have lots going on around here."
# DOESN'T WORK And the response should contain "class=\"author-meta-data\""
And I should see a "span" element with the "class" attribute set to "author-meta-data"

#SOME ROLES CAN ACCESS THE ARTICLE SETTINGS OPTIONS
@api
Scenario Outline: Devs, Admins and SOs can access the Article Settings options; hide Article date
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
