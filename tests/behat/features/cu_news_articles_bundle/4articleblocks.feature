@newsArticles
Feature: News and Articles
In order to display aggregations of articles on different types of node
As an authenticated user
I should be able to create, edit, and delete Article List Blocks

Scenario: Four Article Blocks types are added when bundle is enabled
Given I am logged in as a user with the "site_owner" role
And I am on "block/add"
Then I should see "Article List"
And I should see "Article Feature"
And I should see "Article Grid"
And I should see "Article Slider"


Scenario Outline: An authenticated user can access the form for adding an article list block
    Given I am logged in as a user with the <role> role
    When I go to "block/add/articles"
    Then I should see <message>
    And I go to "block/add/article-feature"
    Then I should see <message2>
    And I go to "block/add/article-grid"
    Then I should see <message3>
    And I go to "block/add/article-slider"
    Then I should see <message4>

    Examples:
      | role                  | message                     | message2                       | message3                    | message4                      |
      | edit_my_content       | "Access denied"             | "Access denied"                | "Access denied"             | "Access denied"               |
      | content_editor        | "Create Article List block" | "Create Article Feature block" | "Create Article Grid block" | "Create Article Slider block" |
      | site_owner            | "Create Article List block" | "Create Article Feature block" | "Create Article Grid block" | "Create Article Slider block" |
      | administrator         | "Create Article List block" | "Create Article Feature block" | "Create Article Grid block" | "Create Article Slider block" |
      | developer             | "Create Article List block" | "Create Article Feature block" | "Create Article Grid block" | "Create Article Slider block" |
      | configuration_manager | "Access denied"             | "Access denied"                | "Access denied"             | "Access denied" |
      | site_editor           | "Create Article List block" | "Create Article Feature block" | "Create Article Grid block" | "Create Article Slider block" |
      | edit_only             | "Access denied"             | "Access denied"                | "Access denied"             | "Access denied" |
      | access_manager        | "Access denied"             | "Access denied"                | "Access denied"             | "Access denied" |


  Scenario: An anonymous user cannot access the form for adding a people list block
    When I am on "block/add/articles"
    Then I should see "Access denied"
    And I go to "block/add/article-feature"
    Then I should see "Access denied"
    And I go to "block/add/article-grid"
    Then I should see "Access denied"
    And I go to "block/add/article-slider"
    Then I should see "Access denied"
    
 Scenario: The Article List Block has been populated with Filters
    Given I am logged in as a user with the "site_owner" role
   And am on "block/add/articles"
   Then I should see "Academics"
   And I should see "Ralphie"
   And I should see "Research"

 Scenario: A simple Article List Block offers several display views
    Given I am logged in as a user with the "site_owner" role
    And am on "block/add/articles"
    And I fill in "Label" with "My Article List Block"
    And I fill in "Title" with "My Article List Block"
    When I select "teaser" from "field_article_display[und]"
 Then I select "feature" from "field_article_display[und]"
 Then I select "feature_large" from "field_article_display[und]"
 Then I select "sidebar" from "field_article_display[und]"
 Then I select "title" from "field_article_display[und]"
 And I press "Save"
 Then I should see "My Article List Block"
 And I should see "An article about Ralphie"
 And I should see "Lunch is served at the Center for Community"

 Scenario: An Article Feature Block offers several display views
    Given I am logged in as a user with the "site_owner" role
    And am on "block/add/article-feature"
    And I fill in "Label" with "My Article Feature Block"
    And I fill in "Title" with "My Article Feature Block"
    When I select "article-feature-inline-2" from "edit-field-article-feature-display-und"
   Then I select "article-feature-inline-3" from "edit-field-article-feature-display-und"
   Then I select "article-feature-stacked" from "edit-field-article-feature-display-und"
   And I select "slider-large" from "edit-field-article-feature-image-size-und"
   And I select "slider" from "edit-field-article-feature-image-size-und"
 And I press "Save"
 Then I should see "My Article Feature Block"
 And I should see "An article about Ralphie"
 And I should see "Lunch is served at the Center for Community"
 
 Scenario: An Article Grid Block offers several display views
    Given I am logged in as a user with the "site_owner" role
    And am on "block/add/article-grid"
   And I fill in "Label" with "My Article Grid Block"
    And I fill in "Title" with "My Article Grid Block"
  When I select "12" from "edit-field-article-grid-items-und"
  When I select "9" from "edit-field-article-grid-items-und"
  When I select "6" from "edit-field-article-grid-items-und"
  When I select "3" from "edit-field-article-grid-items-und"
  And I select "summary-hide" from "edit-field-article-grid-summary-und"
Then I select "summary-display" from "edit-field-article-grid-summary-und"
And I press "Save" 
   Then I should see "My Article Grid Block"
 And I should see "An article about Ralphie"
 And I should see "Ralphie is the mascot at CU Boulder Read more"
 And I should see "Lunch is served at the Center for Community"
 
 Scenario: An Article Slider Block offers several display views
    Given I am logged in as a user with the "site_owner" role
    And am on "block/add/article-slider"
    And I fill in "Label" with "My Article Slider Block"
    And I fill in "Title" with "My Article Slider Block"
  And I check "Ralphie"
And I press "Save" 
 Then I should see "My Article Slider Block"
 And I should see "An article about Ralphie"
 And I should not see "Lunch is served at the Center for Community"
 
  
