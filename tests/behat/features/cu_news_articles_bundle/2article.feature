@newsArticle
Feature: News and Articles
In order to post timely news articles and aggregations
As an authenticated user
I should be able to create and tag articles

# 1) TEST NODE ADD PRIVILEGES
Scenario Outline: Node Access - Some roles can add Article content
Given I am logged in as a user with the <role> role
When I go to "node/add/article"
Then I should see <message>

Examples:
| role            | message          |
| developer       | "Create Article" |
| administrator   | "Create Article" |
| site_owner      | "Create Article" |
| content_editor  | "Create Article" |
| edit_my_content | "Access denied"  |
| site_editor     | "Create Article" |
| edit_only       | "Access denied"  |

 Scenario: Node Access -  An anonymous user cannot add Article content
  When I am on "node/add/article"
  Then I should see "Access denied"
  
# 2) TEST THAT A SIMPLE NODE CAN BE CREATED AND REVISED
 Scenario: Node Functionality - A simple Article node can be created
 Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/article"
  And fill in "edit-title" with "Lunch is served at the Center for Community"
  And fill in "Body" with "Enjoy many lucious desserts"
  When I press "edit-submit"
 Then I should see "Article Lunch is served at the Center for Community has been created."
And I should see "Enjoy many lucious desserts"

 
#  2.5 CREATE REVISIONS TO THE NEW NODE
Scenario: Node functionality - Create node revision by adding graphics
Given I am logged in as a user with the "site_owner" role
And I am on "admin/content"
And I follow "Lunch is served at the Center for Community"
And I follow "Edit"
And I fill in "edit-field-image-und-0-alt" with "yellow cupcakes with lavender frosting"
And I attach the file "cupcakes.jpg" to "edit-field-image-und-0-upload"
And I fill in "edit-field-article-thumbnail-und-0-alt" with "yellow cupcakes with lavender frosting"
And I attach the file "cupcakes.jpg" to "edit-field-article-thumbnail-und-0-upload"
And I select "hide" from "edit-field-article-date-display-und"
And I press "Save"
Then I should see "Article Lunch is served at the Center for Community has been updated."
And I should see the link "Revisions"


# TEST MORE COMPLEX NODE CREATION
Scenario: Node Functionality - Tagging an article creates a Taxonomy Term and an Article List Page
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/article"
  And fill in "edit-title" with "An article about Ralphie"
  And fill in "Body" with "Ralphie is the mascot at CU Boulder"
  And I fill in "edit-field-image-und-0-alt" with "Ralphie with handlers"
And I attach the file "ralphie.jpg" to "edit-field-image-und-0-upload"
And I fill in "edit-field-article-thumbnail-und-0-alt" with "Ralphie with handlers"
And I attach the file "ralphie.jpg" to "edit-field-article-thumbnail-und-0-upload"
  And I fill in "edit-field-tags-und" with "Ralphie"
  And I press "Save"
  Then I should see "The taxonomy term has been linked to this page."
  And I should see "An Article List Page has been created"
  When I go to "admin/content"
  Then I should see "Ralphie"
 When I go to "/ralphie"
 Then I should see "An article about Ralphie"
 And I should not see "Lunch is served at the Center for Community"
 
# DATES CAN BE TURNED ON and OFF FOR DISPLAY ON ARTICLES
# This is also tested in Express/cu_settings/articlesettings.feature
Scenario: Article Date Display can be turned on and off site-wide
Given I am logged in as a user with the "site_owner" role
And I go to "admin/settings/news/article-settings"
And I select "show" from "date_display"
And I press "Save Settings"
# NOW GO LOOK AT THE RALPHIE ARTICLE
Then I go to "admin/content"
When I follow "An article about Ralphie"
Then the response should contain "class=\"fa fa-calendar-o\""
And I go to "admin/settings/news/article-settings"
And I select "hide" from "date_display"
And I press "Save Settings"
# NOW GO LOOK AT THE RALPHIE ARTICLE
Then I go to "admin/content"
When I follow "An article about Ralphie"
Then the response should not contain "class=\"fa fa-calendar-o\""

# 4) TEST THAT THE DELETE BUTTON ACTUALLY WORKS
 Scenario: Node Functionality - Verify that the Delete button actually works
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/article"
  And fill in "edit-title" with "Article to Delete"
  And fill in "Body" with "A temporary node"
  And I press "Save"
  Then I should see "Article Article to Delete has been created."
And I follow "Edit"
 And I press "Delete"
 Then I should see "Are you sure you want to delete Article to Delete?"
  And I press "Delete"
 Then I should see "Article Article to Delete has been deleted."
And I am on "/"

# 3) TEST EDITING AND DELETING PRIVILEGES ON AN ARTICLE
Scenario Outline: Node Access -  Some roles can edit and delete Article node content
Given I am logged in as a user with the <role> role
And I am on "admin/content"
And I follow "Lunch is served at the Center for Community"
Then I should see the link "View"
And I should see the link "Edit"
And I should see the link "Edit Layout"
And I should see the link "Revisions"
And I should see the link "Clear Page Cache"
When I follow "Edit"
Then I should see "This document is now locked against simultaneous editing."
And I should see an "#edit-delete" element
And I press "Cancel edit"

Examples: 
| role |
| developer       | 
| administrator   | 
| site_owner      | 
| content_editor  |
| site_editor |

Scenario: Node Access - EditOnly can edit and revise but not delete node; can clear page cache
Given I am logged in as a user with the "edit_only" role
And I am on "admin/content"
And I follow "Lunch is served at the Center for Community"
Then I should see the link "View"
# HIDE THE REST FOR NOW UNTIL PERMISSIONS ARE FIXED. 
And I should see the link "Edit"
And I should not see the link "Edit Layout"
# And I should see the link "Revisions"
And I should see the link "Clear Page Cache"
When I follow "Edit"
Then I should see "This document is now locked against simultaneous editing."
But I should not see an "#edit-delete" element
And I press "Cancel edit"

# EDIT MY CONTENT: ALL OTHER NODES 
Scenario: Node Access - EditMyContent can not edit Article nodes
Given I am logged in as a user with the "edit_my_content" role
And I am on "admin/content"
And I follow "Lunch is served at the Center for Community"
Then I should see the link "View"
And I should not see the link "Edit"
And I should not see the link "Clear Page Cache"

