@page
Feature: A Basic Page can contain many types of photos
When I create a Basic Page
As an authenticated user
I should be able to upload and place a photo

# An authenticated user should be able to create a basic page node with a photo
@api 
Scenario: Upload Castle
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Castle"
  And fill in "Body" with "All about castles"
  When I attach the file "castle.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "Scenic Photo"
  And I press "Upload"
  And I press "Insert"
  When I press "edit-submit"
  Then I should see "Castle"
  And I should see "All about castles"
  
@api 
Scenario: Upload Cupcakes
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Cupcakes"
  And fill in "Body" with "Demo body content"
  When I attach the file "cupcakes.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "Scenic Photo"
  And I press "Upload"
  And I press "Insert"
 When I press "edit-submit"
  Then I should see "Cupcakes"
  And I should see "Demo body content"

@api 
Scenario: Upload Dog
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "Dog"
  And fill in "Body" with "Demo body content"
When I attach the file "dog.jpg" to "edit-field-photo-und-0-upload"
  And I fill in "edit-field-photo-und-0-alt" with "Scenic Photo"
  And I press "Upload"
  And I press "Insert"
 When I press "edit-submit"
  Then I should see "Dog"
  And I should see "Demo body content"
  
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
  
