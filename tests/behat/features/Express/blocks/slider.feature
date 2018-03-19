@page
Feature: Slider Block
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete a slider

@api
Scenario Outline: An authenticated user should be able to access the form for adding a slider block
  Given  I am logged in as a user with the <role> role
  When I go to "block/add/slider"
  Then I should see <message>

    Examples:
    | role            | message             |
    | edit_my_content | "Access Denied"     |
    | content_editor  | "Create Basic page" |
    | site_owner      | "Create Basic page" |
    | administrator   | "Create Basic page" |
    | developer       | "Create Basic page" |

@api 
Scenario: An anonymous user should not be able to access the form for adding a slider block
  When I am on "block/add/slider"
  Then I should see "Access denied"
  
  @api 
Scenario Outline: An authenticated user should be able to create a slider block
  Given I am logged in as a user with the <role> role
  And I am on "block/add/slider"
 # And fill in "edit-title" with "New Page"
#  And fill in "Body" with "Demo body content"
 # And fill in "Menu link title" with "New Menu Item"
  # When I attach the file "../../../assets/ralphie.jpg" to "edit-field-photo-und-0-upload"
  #   And I press the "Upload" button
  #   And for "Alternate text" I enter "Ralphie running with people"
  #   And I press the "Insert" button
#  When I press "Save"
#  Then the ".page__title" element should contain "New Page"
#  And I should see "Demo body content"
  # And I should see an image in the "Content" region
  # And I should see the image alt "Ralphie running with people" in the "Content" region
  # @todo figure out why text isn't showing up.
#  And I should see "New Menu Item"
      
 Examples:
    | role            | 
    | content_editor  | 
    | site_owner      | 
    | administrator   | 
    | developer       | 
    
