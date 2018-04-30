@blocks @slider
Feature: Slider Block
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete a slider block

Scenario: Block Functionality - A very simple Slider can be created 
 Given I am logged in as a user with the "site_owner" role
  And I am on "block/add/slider"
  And fill in "edit-label" with "Slider Label"
  And fill in "edit-title" with "My Slider Title"
  And I fill in "edit-field-slider-slide-und-0-field-slider-image-und-0-alt" with "Mountain Fantasy"
And I attach the file "behatBanner1.jpg" to "edit-field-slider-slide-und-0-field-slider-image-und-0-upload"
 When I press "edit-submit"
  Then I should be on "block/slider-label/view"
 And I should see "My Slider Title"
 
