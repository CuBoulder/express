
@PhotoGallery
Feature: Photo Gallery Bundle
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete a Photo Gallery


# 2) TEST THAT A SIMPLE PHOTO GALLERY CAN BE CREATED AND REVISED
 Scenario: Node Functionality - A very simple Photo Gallery can be created 
 Given I am logged in as a user with the "site_owner" role
  And I am on "node/add/photo-gallery"
  And fill in "edit-title" with "Gallery One"
  And fill in "Body" with "Click to enlarge"
And I fill in "edit-field-photo-und-0-alt" with "yellow cupcakes with lavender frosting"
And I attach the file "cupcakes.jpg" to "edit-field-photo-und-0-upload"
  When I press "edit-submit"
 Then I should be on "/gallery-one"
 And I should see "Gallery One"
And I should see "Click to enlarge"
And the response should contain "alt=\"yellow cupcakes with lavender frosting\""

#  2.5 CREATE REVISIONS TO THE NEW NODE
Scenario: Node functionality - Create Revision of Photo Gallery node
Given I am logged in as a user with the "site_owner" role
And I am on "admin/content"
And I follow "Gallery One"
And I follow "Edit"
 # BROKEN AT THIS TIME And fill in "edit-name" with "osr-test-edit-own" 
  And fill in "Body" with "Enjoy our Pics"
 And I press "Save"
 Then I should see " Photo Gallery Gallery One has been updated."
  And I should see the link "Revisions"



  # @todo This test fails on Travis after upload around wait step.
  @javascript @files @broken
  Scenario: Create a basic photo gallery.
    Given  I am logged in as a user with the "content_editor" role
      And I am on "node/add/photo-gallery"
      And I fill in "edit-title" with "Test Photo Gallery"
      And I fill in "edit-field-photo-und-0-alt" with "alt one"
      And I fill in "edit-field-photo-und-0-title" with "title one"
      And I attach the file "ralphie.jpg" to "edit-field-photo-und-0-upload"
      And I press "Upload"
      And I wait 5 seconds
      And I fill in "edit-field-photo-und-1-alt" with "alt two"
      And I fill in "edit-field-photo-und-1-title" with "title two"
      And I attach the file "ralphie.jpg" to "edit-field-photo-und-1-upload"
      And I press "Upload"
      And I press "Save"
    Then I should see "Photo Gallery Test Photo Gallery has been created."
    When I click the "img" element with "alt one" for "alt"
      And I wait 5 seconds
    Then I should see "alt one"
    When I click the "#cboxNext" element
    Then I should see "alt two"
    When I click the "#cboxClose" element
    Then I should see "Test Photo Gallery"

 @broken
 Scenario Outline: All users should be able to view a photo gallery node.
    Given  I am logged in as a user with the <role> role
      And I create a "photo_gallery" node with the title "New Gallery"
    Then I should see <message>

    Examples:
      | role            | message        |
      | content_editor  | "New Gallery"  |
      | site_owner      | "New Gallery"  |
      | administrator   | "New Gallery"  |
      | developer       | "New Gallery"  |
      | edit_my_content | "New Gallery"  |
      
@node_creation @broken
  Scenario: An anonymous user should be able to view Photo Gallery content.
      And I create a "photo_gallery" node with the title "New Gallery"
    Then I should see "New Gallery"
