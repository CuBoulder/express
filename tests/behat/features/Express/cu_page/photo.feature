@photo
Feature: A Basic Page can contain many types of photos
When I create a Basic Page
As an authenticated user
I should be able to upload and place a photo


@api 
Scenario: An authenticated user should be able to create a basic page node with a photo
  Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/page"
  And fill in "edit-title" with "New Page"
  And fill in "Body" with "Demo body content"
  When I attach the file "../../../assets/ralphie.jpg" to "edit-field-photo-und-0-upload"
  And for "Alternate text" I enter "Ralphie running with people"
  And I press the "Upload" button
  #   And for "Alternate text" I enter "Ralphie running with people"
  #   And I press the "Insert" button
  When I press "Save"
  Then the ".page__title" element should contain "New Page"
  And I should see "Demo body content"
  # And I should see an image in the "Content" region
  # And I should see the image alt "Ralphie running with people" in the "Content" region
  And I should see "New Menu Item"
