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
  And I fill in "edit-field-photo-und-0-alt" with "Scenic Photo"
  And I press "Upload"
  And I press "Insert"
  And I press "Save"
  Then I should see "New Page"
  And I should see "Demo body content"
