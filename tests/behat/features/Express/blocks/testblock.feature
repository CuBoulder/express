@blocks
Feature: Text Block Block
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete a text block

@api
Scenario Outline: An authenticated user should be able to access the form for adding a text block block
  Given I am logged in as a user with the <role> role
  When I go to "block/add/block"
  Then I should see <message>

    Examples:
    | role            | message                   |
    | edit_my_content | "Access Denied"           |
    | content_editor  | "Create Text Block block" |
    | site_owner      | "Create Text Block block" |
    | administrator   | "Create Text Block block" |
    | developer       | "Create Text Block block" |

@api 
Scenario: An anonymous user should not be able to access the form for adding a text block block
  When I am on "block/add/block"
  Then I should see "Access denied"
  
@api
Scenario: A basic Text Block block can be created
  Given I am logged in as a user with the "site_owner" role
  And I am on "block/add/block"
 And fill in "edit-label" with "New Text Block"
 And fill in "edit-title" with "New Text Block Title"
 # THIS NEXT LINE IS A WORKAROUND FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
# And I follow "Disable rich-text"
And fill in "Body" with "An informative block of text about our program"
 And I press "Save"
 Then I should see "New Text Block Title"
 And I should see "An informative block of text about our program"

# NOTE THAT THE INSERT BUTTON IS IMPOSSIBLE TO TARGET AT THIS TIME
@api
Scenario: A graphic can be uploaded to a Text Block
  Given I am logged in as a user with the "site_owner" role
  And I am on "block/add/block"
 And fill in "edit-label" with "My Text Block"
 And fill in "edit-title" with "My New Text Block"
And fill in "Body" with "Lorem ipsum dolor sit amet"
 And I attach the file "assets/cupcakes.jpg" to "edit-field-block-photo-und-0-upload"
  And I fill in "edit-field-block-photo-und-0-alt" with "Lavender and lemony goodness"
  And I press "edit-field-block-photo-und-0-upload-button"
 Then I should see "File information"
 And I press "Save"
 Then I should see "My New Text Block"
 And I should see "Lorem ipsum dolor sit amet"
