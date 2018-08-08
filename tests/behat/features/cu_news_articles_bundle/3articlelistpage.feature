@newsArticles
Feature: News and Articles
In order to display aggregations of articles
As an authenticated user
I should be able to create, edit, and delete Article List Page content

 Scenario Outline: An authenticated user should be able to access the form for adding people list page content
    Given I am logged in as a user with the <role> role
    When I go to "node/add/article-list-page"
    Then I should see <message>

    Examples:
      | role                  | message                   |
      | edit_my_content       | "Access denied"           |
      | content_editor        | "Create Article List Page" |
      | site_owner            | "Create Article List Page" |
      | administrator         | "Create Article List Page" |
      | developer             | "Create Article List Page" |
      | configuration_manager | "Access denied"           |
      | site_editor           | "Create Article List Page" |
      | edit_only             | "Access denied"           |
      | access_manager        | "Access denied"           |


  Scenario: An anonymous user should not be able to access the form for adding people list page content
    When I am on "node/add/article-list-page"
    Then I should see "Access denied"
    
 Scenario: A Simple Article List page display all articles created
Given I am logged in as a user with the "site_owner" role
When I go to "node/add/article-list-page"
And  I fill in "edit-title" with "News Page"
And I press "Save"
Then I should see "News Page"
And I should see "An article about Ralphie"
And I should see "Lunch is served at the Center for Community"
    
    Scenario: The Article List Page provides several display/format types
    Given I am logged in as a user with the "site_owner" role
    And am on "node/add/article-list-page"
   # And I click the ".group-people-list-display.field-group-fieldset a.fieldset-title" element
  #  And I select "Table" from "edit-field-people-list-display-und"
  #  And I select "Grid" from "edit-field-people-list-display-und"
  #  And I select "List" from "edit-field-people-list-display-und"
    
