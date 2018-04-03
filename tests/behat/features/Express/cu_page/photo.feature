@page @photo
Feature: A Basic Page can contain many types of photos
When I create a Basic Page
As an authenticated user
I should be able to upload and place a photo

# An authenticated user should be able to create a basic page node with a photo
#TEST ONE: A GRPAHIC CAN BE UPLOADED
@api 
Scenario: Upload Castle Graphic
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Castles"
  And I fill in "Body" with "The development of defensive architecture"
  And I attach the file "castle.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "Castle Photo"
  When I press "edit-submit"
  Then I should see "Castles"
  And I should see "The development of defensive architecture"
  
@api 
#TEST TWO: UPLOADING, THEM COMING BACK AND INSERTING THE GRAPHIC
Scenario: Upload Cupcakes Graphic
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Cupcakes"
 And fill in "Body" with "Little cakes with frosting"
 And I attach the file "cupcakes.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "Yummy goodness"
 And I press "edit-submit"
 And I follow "Edit"
 Then I should see "This document is now locked against simultaneous editing"
 # And I press "Insert"
 When I press "image_image"
 And I press "edit-submit"
  Then I should see "Cupcakes"
  And I should see "Little cakes with frosting"
  And I should see "Yummy goodness"
 
 
 #TEST THREE 
@api 
Scenario: Upload Dog
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Dog"
  And fill in "Body" with "Who is a good dog"
  And I attach the file "dog.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "My dog"
  And I press "edit-field-photo-und-0-upload-button"
  And I wait for AJAX
  And I press "image_image"
 When I press "edit-submit"
  Then I should see "Dog"
  And I should see "Who is a good dog"
 
  
  @api 
  Scenario: Upload Old Main
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Old Main"
  And fill in "Body" with "Demo body content"
When I attach the file "../../../main.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "Scenic Photo"
  And I press "Upload"
  And I press "Insert"
  When I press "Save"
  Then I should see "Old Main"
  And I should see "Demo body content"
  
  @api 
  Scenario: Upload Seagull
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Seagull"
  And fill in "Body" with "Demo body content"
When I attach the file "../../../../seagull.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "Scenic Photo"
  And I press "Upload"
  And I press "Insert"
  When I press "Save"
  Then I should see "Seagull"
  And I should see "Demo body content"
  
 @api 
 Scenario: Upload Mountains
  Given I am logged in as a user with the "site_owner" role
   And I am on "node/add/page"
  And fill in "edit-title" with "Mountains"
  And fill in "Body" with "Demo body content"
When I attach the file "assets/mountains.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "Scenic Photo"
  And I press "Upload"
  And I press "Insert"
  When I press "Save"
  Then I should see "Mountains"
  And I should see "Demo body content"
  
  Scenario: Upload Ralphie
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Ralphie"
  And fill in "Body" with "Demo body content"
When I attach the file "../../assets/ralphie.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "Scenic Photo"
  And I press "Upload"
  And I press "Insert"
  When I press "Save"
  Then I should see "Ralphie"
  And I should see "Demo body content"
  
    Scenario: Upload Saab
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Saab"
  And fill in "Body" with "Demo body content"
When I attach the file "../../../assets/saab.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "Scenic Photo"
  And I press "Upload"
  And I press "Insert"
  When I press "Save"
  Then I should see "Saab"
  And I should see "Demo body content"
  
  Scenario: Upload Sunset
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Sunset"
  And fill in "Body" with "Demo body content"
When I attach the file "../../../../assets/sunset.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "Scenic Photo"
  And I press "Upload"
  And I press "Insert"
  When I press "Save"
  Then I should see "Sunset"
  And I should see "Demo body content"
  
