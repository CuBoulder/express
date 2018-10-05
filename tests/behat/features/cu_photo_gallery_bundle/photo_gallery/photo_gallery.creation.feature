@PhotoGallery
Feature: Photo Gallery Bundle
When I login to a Web Express website
As a user with the proper role
I should be able to create, edit, and delete a Photo Gallery

# 2) TEST THAT A SIMPLE PHOTO GALLERY CAN BE CREATED
Scenario: Node Functionality - A very simple Photo Gallery can be created 
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/photo-gallery"
And fill in "edit-title" with "My Photos"
And fill in "Body" with "Click to enlarge"
And I fill in "edit-field-photo-und-0-alt" with "yellow cupcakes with lavender frosting"
And I attach the file "cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I press "Upload"
# And I wait for the ".form-item-field-photo-und-1" element to appear
And I wait 5 seconds
Then I check "edit-menu-enabled"
And I fill in "edit-menu-link-title" with "Photos Link"
And I press "Save"
Then I should be on "/my-photos"
And I should see "Photos Link"
And I should see "My Photos"
And I should see "Click to enlarge"
And the response should contain "class=\"colorbox\""

#  2.5 CREATE REVISIONS TO THE NEW NODE
Scenario: Node functionality - Create Revision of Photo Gallery node by adding new photo
Given I am logged in as a user with the "site_owner" role
And I am on "admin/content"
And I follow "My Photos"
And I follow "Edit"
And I fill in "edit-field-photo-und-1-alt" with "Ralphie and handlers"
And I attach the file "ralphie.jpg" to "edit-field-photo-und-1-upload"
And I press "Save"
Then I should see "Photo Gallery My Photos has been updated."
And I should see the link "Revisions"
And the response should contain "alt=\"Ralphie and handlers\""

Scenario: Create a basic photo gallery with three photos
  Given  I am logged in as a user with the "site_editor" role
  And I am on "node/add/photo-gallery"
  And I fill in "edit-title" with "Test Photo Gallery"
  And I fill in "edit-field-photo-und-0-alt" with "Ralphie Alt Text"
  And I fill in "edit-field-photo-und-0-title" with "Ralphie Title Text"
  And I attach the file "ralphie.jpg" to "edit-field-photo-und-0-upload"
  And I press "Upload"
  And I wait 5 seconds
  And I fill in "edit-field-photo-und-1-alt" with "Cupcakes Alt Text"
  And I fill in "edit-field-photo-und-1-title" with "Cupcakes Title Text"
  And I attach the file "cupcakes.jpg" to "edit-field-photo-und-1-upload"
  And I press "Upload"
  And I wait 5 seconds
  And I fill in "edit-field-photo-und-2-alt" with "Fantasy Mtns Alt Text"
  And I fill in "edit-field-photo-und-2-title" with "Fantasy Mtns Title Text"
  And I attach the file "behatBanner1.jpg" to "edit-field-photo-und-2-upload"
  And I press "Upload"
  And I press "Save"
  Then I should see "Photo Gallery Test Photo Gallery has been created."
  And the response should contain "class=\"colorbox\""
  
Scenario: Node Access -  EditOnly can edit and revise but not delete node; can clear page cache
  Given I am logged in as a user with the "edit_only" role
  And I am on "test-photo-gallery"
  And I should see the link "Edit"
  And I should not see the link "Edit Layout"
  And I should see the link "Clear Page Cache"
  When I follow "Edit"
  Then I should see "This document is now locked against simultaneous editing."
  And I should not see an "#edit-delete" element
  And I press "Cancel edit"

Scenario: An anonymous user should be able to view Photo Gallery content.
Given I am on "/my-photos"
Then I should see "My Photos"
