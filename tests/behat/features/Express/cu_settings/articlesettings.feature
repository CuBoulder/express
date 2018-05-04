@settings
Feature: Article Settings allow the user to hide/show an article's published date
In order to show or hide an article's published date
An authenticated user with the proper role
Should be able to set Article Settings options

#SOME ROLES CAN ACCESS THE ARTICLE SETTINGS OPTIONS
@api
Scenario Outline: A user with the proper role can access the Article Settings options
 Given I am logged in as a user with the <role> role
 When I go to "admin/settings/news/article-settings"
 Then I should see <message>
    
Examples:
    | role            | message                          |
    | developer       | "Article Published Date Display" |
    | administrator   | "Article Published Date Display" |
    | site_owner      | "Article Published Date Display" |
    | content_editor  | "Access denied" |
    | edit_my_content | "Access denied" |
    | site_editor      | "Access denied" |
    | edit_only        | "Access denied" |
    | access_manager   | "Access denied" |
    | configuration_manager | "Article Published Date Display" |
    
 @api 
Scenario: An anonymous user cannot access the Article Settings options
  When I am on "admin/settings/news/article-settings"
  Then I should see "Access denied"
  
#CHANGING THE SETTINGS HIDES THE PUBLISHED DATE ON ARTICLE
@api
Scenario Outline: User can change the Article Settings; aka hide publish date on article
 Given I am logged in as a user with the <role> role
 And am on "admin/settings/news/article-settings"
 When I select "hide" from "date_display"
 And I press "edit-submit"
 Then I should see "Article settings have been saved."
 And I go to "node/add/article"
 And I fill in "edit-title" with "A New Article"
 And I fill in "Body" with "Here is more information."
 And I press "Save"
 Then I should see "A New Article"
 And I should not see a ".author-meta-date" element
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 
    | configuration_manager |
