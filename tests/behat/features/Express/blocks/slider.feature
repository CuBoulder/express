@slider @block
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
  
@api @broken
Scenario Outline: An authenticated user should be able to create a slider block
  Given I am logged in as a user with the <role> role
  And I am on "block/add/slider"
 And fill in "edit-label" with "Homepage Slider"
 And fill in "edit-title" with "Slider Title"
 And I select "slider" from "edit-field-slider-size-und"
 And I select "5" from "edit-field-slider-design-style-und"
 # AND I ADD A PICTURE - CANT WORK THIS WITHOUT A GRAPHIC
 And I fill in "edit-field-slider-slide-und-0-field-slider-image-und-0-alt" with "Scenic Photo Number One"
 And I fill in "edit-field-slider-slide-und-0-field-slider-caption-und-0-value" with "This is an important picture"
 And I fill in "edit-field-slider-slide-und-0-field-slider-link-und-0-url" with "https://www.colorado.edu"
 And I press "Save"
 Then I should see "Slider Title"
 And I should see "This is an important picture"
      
 Examples:
    | role            | 
    | content_editor  | 
    | site_owner      | 
    | administrator   | 
    | developer       | 
    
 
