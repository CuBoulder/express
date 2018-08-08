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
    
    Scenario: The Provide Menu Link box should be checked on node creation but remain unchecked if unchecked.
    Given I am logged in as a user with the "site_owner" role
    When I go to "node/add/article-list-page"
      And  I fill in "edit-title" with "Article List Page"
    Then the "edit-menu-enabled" checkbox should be checked
    When I uncheck "edit-menu-enabled"
      And I press "Save"
      And I follow "Edit"
    Then the checkbox "edit-menu-enabled" should be unchecked
    
   Scenario: Tagging an article creates an Article List Page
  Given I am logged in as a user with the "site_owner" role
  And I am on "admin/content"
  And I follow "Lunch is served at the Center for Community"
  And I follow "Edit"
  And I fill in "edit-field-tags-und" with "Campus Life"
  And I press "Save"
  Then I should see "The taxonomy term has been linked to this page."
  And I should see "An Article List Page has been created"
  When I go to "admin/content"
  Then I should see "Campus Life"
 When I am on "/campus-life"
 Then I should see "Lunch is served at the Center for Community"
  
    Scenario: The Article List Page provides several display/format types
    Given I am logged in as a user with the "site_owner" role
    And am on "node/add/article-list-page"
   # And I click the ".group-people-list-display.field-group-fieldset a.fieldset-title" element
  #  And I select "Table" from "edit-field-people-list-display-und"
  #  And I select "Grid" from "edit-field-people-list-display-und"
  #  And I select "List" from "edit-field-people-list-display-und"
    
