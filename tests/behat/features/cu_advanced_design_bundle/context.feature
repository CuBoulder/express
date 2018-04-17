# CONTEXT FUNCTIONALITY IS TESTED IN OTHER FEATURES. THIS FEATURE TARGETS SITE BACKGROUND IMAGES ONLY

@AdvDesign
Feature: Add a Site Background image with Context
In order to add visual interest to my site
As an authenticated user
I should be able to add a background image to my site

# THIS TEST UPLOADS A GRAPHIC. WE CANT TAKE IT FURTHER UNTIL WE CAN KNOW WHAT NODE NUMBER WAS ASSIGNED
Scenario: An authenticated user can attach a background image to a site
    Given I am logged in as a user with the "site_owner" role
    When I go to "node/add/file"
    And I fill in "edit-title" with "Background Graphic"
    And I attach the file "cupcakes.jpg" to "edit-field-file-attachment-und-0-upload"
    And I press "Upload"
    Then I should see "File Information"
    And I should see "Operations"
    And I press "edit-submit"
    Then I should see "/backstretch"
# TO DO - WRITE A CUSTOM STEP TO FIGURE OUT THE NODE NUMBER
# THEN CHANGE SITE THEME TO A BOXED DESIGN
# THEN USE CONTEXT TO PLACE THE NODE/#/BACKSTRETCH ON THE SITE WIDE CONTEXT
# AND THE RESPONSE FROM THE SERVER WILL INCLUDE 'BACKSTRETCH'
# SPECIFICALLY profiles\/express\/modules\/custom\/backstretch\/bs.js

