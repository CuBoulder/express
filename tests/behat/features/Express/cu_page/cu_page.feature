@page
Feature: Basic Page Content Type
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete page content

@api
Scenario Outline: A user with the proper role should be able to access the form for adding basic page content
  Given I am logged in as a user with the <role> role
  When I go to "node/add/page"
  Then I should see <message>

    Examples:
    | role            | message             |
    | edit_my_content | "Access Denied"     |
    | content_editor  | "Create Basic page" |
    | site_owner      | "Create Basic page" |
    | administrator   | "Create Basic page" |
    | developer       | "Create Basic page" |

@api 
Scenario: An anonymous user should not be able to access the form for adding page content
  When I am on "node/add/page"
  Then I should see "Access denied"
  
@api 
Scenario: A very basic Basic Page node can be created 
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "My Page"
  And fill in "Body" with "Lorem ipsum dolor sit amet"
  When I press "edit-submit"
 Then I should see "My Page"
  And I should see "Lorem ipsum dolor sit amet"
  
#UPLOADING A GRAPHIC - THIS WORKS
@api
Scenario: A graphic can be uploaded into a Basic Page
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "About Ralphie"
  # THIS NEXT LINE IS A WORKAROUND FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
  # And I follow "Disable rich-text"
  And fill in "Body" with "Ralphie the Buffalo is the name of the live mascot of the University of Colorado Buffaloes."
 And I attach the file "ralphie.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Ralphie Buffalo with handlers"
  When I press "edit-submit"
  Then I should see "About Ralphie"
  And I should see "Ralphie the Buffalo is the name of the live mascot of the University of Colorado Buffaloes."

 #INSERTING A GRAPHIC
@api @javascript
Scenario: A graphic can be inserted into a Basic Page
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Buffalo"
  # THIS NEXT LINE WILL FIND THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
  And I follow "Disable rich-text"
  And fill in "Body" with "The first Ralphie was donated to the school in 1966."
 And I attach the file "ralphie.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Ralphie with her handlers"
  And I press "edit-field-photo-und-0-upload-button"
  And I wait 10 seconds
  And I press "Insert"
  And I wait 10 seconds
 And I press "edit-submit"
  Then I should see "Buffalo"
  And I should see "The first Ralphie was donated to the school in 1966."
 # Then the response should contain "alt=\"Ralphie Buffalo with handlers\""
 
 
#INSERTING A GRAPHIC
@api @rebuild
Scenario: A graphic can be inserted into a Basic Page
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Buffalo"
  # THIS NEXT LINE IS A WORKAROUND FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
  # And I follow "Disable rich-text"
  And fill in "Body" with "The first Ralphie was donated to the school in 1966."
  
 And I attach the file "ralphie.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Ralphie with her handlers"
  And I press "edit-field-photo-und-0-upload-button"
  And I wait 10 seconds
  And I press "Insert"
  And I wait 10 seconds
 And I press "edit-submit"
  Then I should see "Buffalo"
  And I should see "The first Ralphie was donated to the school in 1966."
 # Then the response should contain "alt=\"Ralphie Buffalo with handlers\""

@api 
Scenario: The provide menu link box should be checked on node creation but remain unchecked if user chooses to uncheck that box.
Given I am logged in as a user with the "site_owner" role
When I go to "node/add/page"
And I fill in "edit-title" with "Not In Menu"
Then the "edit-menu-enabled" checkbox should be checked
When I uncheck "edit-menu-enabled"
And I press "Save"
# ADD CHECK FOR PAGE TITLE
Then I should see "Not In Menu"
And I follow "Edit"
Then the checkbox "edit-menu-enabled" should be unchecked

@api 
Scenario Outline: An authenticated user can delete a basic page
  Given I am logged in as a user with the <role> role
  When I go to "node/add/page"
  And  I fill in "edit-title" with "Test Page"
  And I press "Save"
  And I follow "Edit"
  And I press "Delete"
  Then I should see "Are you sure you want to delete Test Page?"
  And I press "Delete"
  Then I am on "/"
    
    Examples:
    | role            | 
    | content_editor  | 
    | site_owner      | 
    | administrator   | 
    | developer       | 
