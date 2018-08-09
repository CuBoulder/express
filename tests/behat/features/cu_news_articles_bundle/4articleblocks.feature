@newsArticles
Feature: News and Articles
In order to display aggregations of articles on different types of node
As an authenticated user
I should be able to create, edit, and delete Article List Blocks

Scenario: Enabling the News bundle creates four types of blocks
# http://tuesday.test/block/add

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

    Examples:
      | role                  | message                     |
      | edit_my_content       | "Access denied"             |
      | content_editor        | "Create Article List block" |
      | site_owner            | "Create Article List block" |
      | administrator         | "Create Article List block" |
      | developer             | "Create Article List block" |
      | configuration_manager | "Access denied"             |
      | site_editor           | "Create Article List block" |
      | edit_only             | "Access denied"             |
      | access_manager        | "Access denied"             |


  Scenario: An anonymous user cannot access the form for adding a people list block
    When I am on "block/add/articles"
    Then I should see "Access denied"


  Scenario Outline: A simple Article List Block offers several display views
    Given I am logged in as a user with the "site_owner" role
    And am on "block/add/articles"
    And I fill in "Label" with "My Article List Block"
    And I fill in "Title" with "My Article List Block"
    When I select "teaser" from "field_article_display[und]"
 Then I select "feature" from "field_article_display[und]"
 Then I select "feature_large" from "field_article_display[und]"
 Then I select "sidebar" from "field_article_display[und]"
 Then I select "title" from "field_article_display[und]"
 Then print last response
 And I press "Save"
 Then I should see "My Article List Block"
 And I should see "An article about Ralphie"
 And I should see "Lunch is served at the Center for Community"


   @javascript
  Scenario: The People List Block has been populated with Filters
    Given I am logged in as a user with the "site_owner" role
    And am on "block/add/people-list-block"
    And I click the ".group-people-list-filter.field-group-fieldset a.fieldset-title" element
    And I should see "Geophysics"
    And I should see "Technology"
    Then I should see "Faculty"
    Then I should see "Staff"
    And I should see "Honeywell"
    And I should see "Marietta"
    And I should see "Design"
    And I should see "Law"


  Scenario: A simple People List Block can be created
    Given I am logged in as a user with the "content_editor" role
    And am on "block/add/people-list-block"
    And fill in "edit-label" with "Simple People Block Label"
    And fill in "edit-title" with "Simple People Block Title"
    When I press "Save"
    Then I should be on "block/simple-people-block-label/view"
    And I should see "People List Block Simple People Block Title has been created."
    And I should see "Alejandro FacGeoHoneyLaw"
    And I should see "Abdullah FacTechMariDes"
    And I should see "Deshawn StaffGeoMariDes"
    And I should see "Kendall StaffTechHoneyLaw"


  Scenario: The People List Block can filter out persons
    Given I am logged in as a user with the "site_owner" role
    And am on "block/add/people-list-block"
   # And I click the ".group-people-list-filter.field-group-fieldset a.fieldset-title" element
  # And I check "edit-field-people-filter-1-und-8"
    And fill in "edit-label" with "Research Group Block Label"
    And fill in "edit-title" with "Research Group Block Title"
    And I check "Honeywell"
    And I press "Save"
    Then I should see "Research Group Block Title"
    And I should see "Alejandro FacGeoHoneyLaw"
    And I should see "Kendall StaffTechHoneyLaw"


 Scenario Outline: An Article Feature Block offers several display views
    Given I am logged in as a user with the "site_owner" role
    And am on "block/add/article-feature"
    And I fill in "Label" with "My Article Feature Block"
    And I fill in "Title" with "My Article Feature Block"
    When I select "article-feature-inline-2" from "edit-field-article-feature-display-und"
   Then I select "article-feature-inline-3" from "edit-field-article-feature-display-und"
   Then I select "article-feature-inline-stacked" from "edit-field-article-feature-display-und"
   And I select "slider-large" from "edit-field-article-feature-image-size-und"
   And I select "slider" from "edit-field-article-feature-image-size-und"
 And I press "Save"
 Then I should see "My Article List Block"
 And I should see "An article about Ralphie"
 And I should see "Lunch is served at the Center for Community"
