@settings
Feature: RSS Feeds
In order to allow other sites to display the site articles
An authenticated user with the proper role
Should be able to create an RSS feed of the site articles

#SOME ROLES CAN ACCESS RSS FEED SETTINGS
@api
Scenario Outline: Devs, Admins and SOs can view the RSS feeds
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/feeds/rss/overview"
  Then I should see "Manage RSS Feeds"
  And I should see the link "Add a RSS Feed"
  
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 
    

#CREATE AN ARTICLE
 @api 
Scenario: An authenticated user should be able to create article node
  Given  I am logged in as a user with the "site_owner" role
  And am on "node/add/article"
  When fill in "Title" with "Read About Ducks"
  And fill in "Body" with "Demo body content"
  And I press "Save"
  Then I should see "Read About Ducks"

#SOME ROLES CAN USE THE RSS FEED BUILDER
@api
Scenario Outline: Devs, Admins and SOs create an RSS feed
  Given I am logged in as a user with the <role> role
 When I go to "admin/settings/feeds/rss/add"
 Then I should see "Build custom RSS feeds"
 And I fill in "edit-rss-title" with "Exciting News"
 And I press "edit-submit"
 Then I should see "Exciting News"
 And I should see "feed/rss.xml"
  
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 
  
# SOME ROLES CAN NOT ACCESS RSS FEED SETTINGS
@api 
Scenario Outline: CEs and EMCs should not be able to set site name
Given I am logged in as a user with the <role> role
When I go to "admin/settings/feeds/rss/overview"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
 
 
# SOME ROLES CAN NOT ACCESS THE RSS FEED BUILDER
@api 
Scenario Outline: CEs and EMCs should not be able to set site name
Given I am logged in as a user with the <role> role
When I go to "admin/settings/feeds/rss/add"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
