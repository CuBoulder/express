@photo
Feature: A Basic Page can contain many types of photos
When I create a Basic Page
As an authenticated user
I should be able to upload and place a photo

#THIS TEST UPLOADS A GRAPHIC; SAVES, THEN VERIFIES THAT IT HAS BEEN UPLOADED AND THAT WE ARE ON CORRECT PAGE
@api 
Scenario: A graphic can be uploaded by saving the page
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Castles"
  And I fill in "Body" with "The development of defensive architecture"
  And I attach the file "assets/castle.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "A ruined castle in the fog"
  And I press "edit-submit"
 And I follow "Edit"
 Then I should see "Edit Basic page Castles"
 # THIS NEXT LINE PROVES IT WAS UPLOADED
And I should see "File information"
 And I should see "Click and drag the crosshair to target the most important portion of the image"
 And I should see "castle.jpg"
 And I should see "Insert"
 And I press "edit-submit"
  Then I should be on "/castles"
  And I should see "Castles"
  And I should see "The development of defensive architecture"
  
@api 
#TEST TWO: THIS TEST UPLOADS A GRAPHIC USING THE 'UPLOAD' BUTTON
Scenario: A graphic can be uploaded and inserted into a page
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Cupcakes"
 And fill in "Body" with "Little cakes with frosting"
 And I attach the file "assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
  And I press "edit-field-photo-und-0-upload-button"
  And I wait 5 seconds
 Then I should see "File information"
 And I should see "Click and drag the crosshair to target the most important portion of the image"
 And I should see "cupcakes.jpg"
 And I should see "Insert"
  And I click "Insert"
 And I press "edit-submit"
  Then I should be on "/cupcakes"
  And I should see "Cupcakes"
  And I should see "Little cakes with frosting"
And the response should contain "alt=\"Lavender and lemony goodness\"
 
@api 
#TEST THREE
Scenario: Upload Dog Graphic
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Dogs"
 And fill in "Body" with "Demo body content"
 And I attach the file "assets/dog.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "Red heeler with sunflower"
 And I press "edit-submit"
 Then I should see "Dogs"
 And I follow "Edit"
 Then I should see "Edit Basic page Dogs"
 Then I should see "This document is now locked against simultaneous editing"
And I should see "File information"
 And I should see "Click and drag the crosshair to target the most important portion of the image"
 And I should see "dog.jpg"
 # SYSTEM CANNOT FIND THE SELECT OPTIONS
 And I select "image_hero" from "Style:"
 And I click "Insert"
 And I press "edit-submit"
  Then I should be on "/dogs"
  And I should see "Dogs"
  And I should see "Demo body content"
  And the response should contain "alt=\"Red heeler with sunflower\""

 
@api 
#TEST FIVE
Scenario: Upload Mountains Graphic
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Mountains"
 And fill in "Body" with "Demo body content"
 And I attach the file "assets/mountains.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "Pink clouds, blue mountains"
 And I press "edit-field-photo-und-0-upload-button"
  And I wait 5 seconds
 Then I should see "File information"
 And I should see "Click and drag the crosshair to target the most important portion of the image"
 And I should see "mountains.jpg"
 And I should see "Insert"
   And I select "colorbox__square" from "Style:"
  #CAN WE INSERT THIS?
 And I click "Insert"
 And I press "edit-submit"
  Then I should be on "/mountains"
  And I should see "Mountains"
  And I should see "Demo body content"
 And the response should contain "alt=\"Pink clouds, blue mountains\""
  

