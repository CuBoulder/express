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
  And I should see "My Page"
  And I should see "Lorem ipsum dolor sit amet"
  
  
#UPLOADING A GRAPHIC
@api 
Scenario: A graphic can be inserted into a Basic Page
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Photo Page"
  # THIS NEXT LINE IS A WORKAROUND FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
  # And I follow "Disable rich-text"
  And fill in "Body" with "Demo body content"
  And I attach the file "ralphie.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "Ralphie Running with Handlers"
  And I press "Upload"
  And I press "Insert"
  When I press "edit-submit"
  And I should see "Photo Page"
  And I should see "Demo body content"
Then the response should contain "alt=\"Ralphie Running with Handlers\""

 
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
