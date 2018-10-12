@wysiwyg
Feature: WYSIWYG Feature
When I login to the website
As a user with the proper role
I should be able to use the full functionality of the WYSIWYG editor

@javascript 
Scenario: A site owner should be able to add a video shortcode
Given I am logged in as a user with the "site_owner" role
When I go to "node/add/page"
And I wait for the "#cke_1_top" element to appear
And I fill in "Title" with "My Video Shortcode"
And I press "Video Shortcode Generator"
And I fill in "video URL" with "https://www.youtube.com/watch?v=m-m7mBSw-5k"
And I press "OK"
And I press "Save"
#Then I should see "My Video Shortcode"
# @todo Figure out a step definition for elements.
#And I should see a ".video-filter" element

@javascript 
Scenario: A site owner should be able to add a button shortcode
Given I am logged in as a user with the "site_owner" role
When I go to "node/add/page"
And I wait for the "#cke_1_top" element to appear
And I fill in "Title" with "My Button Shortcode"
And I press "Button Shortcode Generator"
And I fill in "Button Text" with "New Button"
And I fill in "URL" with "http://www.google.com"
      # @todo Figure out why OK button is weird here.
And I press "OK"
And I press "Save"
    #Then I should see "My Button Shortcode"
    #Then I should see "New Button"
      #And I click "New Button"
    #Then I should see a "#hplogo" element

  @javascript @files @broken
  Scenario: A site owner should be able to add an image caption shortcode
  Given I am logged in as a user with the "site_owner" role
    When I go to "node/add/page"
      And I wait for the "#cke_1_top" element to appear
      And I fill in "Title" with "My Image Caption Shortcode"
      And I attach the file "ralphie.jpg" to the "edit-field-photo-und-0-upload" field
      And I fill in "Alternate text" with "Ralphie"
      And I press "Upload"
    Then I should see a ".image-widget-data" element
    When I press "Insert"
      # @todo Figure out how to switch to iframe contexts http://apigen.juzna.cz/doc/Behat/Mink/source-class-Behat.Mink.Driver.DriverInterface.html#163-171
      # And I press the "Image Caption Shortcode Generator" button
      # And I fill in "Image Caption" with "Ralphie Run"
And I press "OK"
And I press "Save"
    # Then I should see "My Image Caption Shortcode"
    # Then I should see "New Button"

  @javascript
  Scenario: A site owner should be able to add an icon shortcode
  Given I am logged in as a user with the "site_owner" role
    When I go to "node/add/page"
      And I wait for the "#cke_1_top" element to appear
      And I fill in "Title" with "My Icon Shortcode"
      And I press "Icon Shortcode Generator"
      And I select "ambulance" from "Icon [View Icons]"
      And I select "fa-5x" from "Icon Size"
      And I select "Black" from "Icon Color"
      And I select "square" from "Icon Wrapper"
And I press "OK"
And I press "Save"
    #Then I should see a ".fa-ambulance.icon-color-black.icon-wrapper-square" element

  @javascript 
  Scenario: A site owner should be able to add a give button shortcode
  Given I am logged in as a user with the "site_owner" role
    When I go to "node/add/page"
      And I wait for the "#cke_1_top" element to appear
      And I fill in "Title" with "My Give Button Shortcode"
      And I press "Give Button Shortcode Generator"
      And I select "light" from "give Color"
      And I fill in "Give Button Text" with "Give Now!"
      And I fill in "URL" with "http://www.google.com"
      And I select "large" from "Give Button Size"
      And I select "full" from "Give Button Style"
      # @todo Figure out why OK button is weird here.
And I press "OK"
And I press "Save"
    #Then I should see "Give Now!"
      #And I should see a ".cu-give-button.button-large.button-full.cu-give-button-light" element
    #When I click "Give Now!"
    #Then I should see a "#hplogo" element

  @javascript 
  Scenario: A site owner should be able to add a expand content shortcode
Given I am logged in as a user with the "site_owner" role
    When I go to "node/add/page"
      And I wait for the "#cke_1_top" element to appear
      And I fill in "Title" with "My Expandable Content Shortcode"
      And I press "Expand Content Shortcode Generator"
      And I fill in "Title" with "Example FAQ #1"
      And I fill in "Expand Content Text" with "Example content #1"
      # @todo Figure out why OK button is weird here.
      #And I press the "Expand Content Shortcode Generator" button
      #And I fill in "Title" with "Example FAQ #2"
      #And I fill in "Expand Content Text" with "Example content #2"
And I press "OK"
And I press "Save"
    #Then I should see "Example FAQ #1"
      #And I should see "Example FAQ #2"
    #When I click "Example FAQ #1"
    #Then I should see "Example content #1"
      #And I should not see the text "Example content #2"
    #When I click "Example FAQ #1"
      #And I click "Example FAQ #2"
    #Then I should see "Example content #2"
      #And I should not see "Example content #1"

  @javascript
  Scenario: A site owner should be able to add a map embed shortcode
 Given I am logged in as a user with the "site_owner" role
    When I go to "node/add/page"
      And I wait for the "#cke_1_top" element to appear
      And I fill in "Title" with "My Map Shortcode"
      And I press "Map Shortcode Generator"
      And print last response
      And I fill in "Map Embed Code" with "https://www.colorado.edu/map/?id=336&em=1&open=0#?mc/39.997204,-105.250175?z/17"
And I press "OK"
And I press "Save"

    
  @javascript 
  Scenario: A site owner should be able to add a box shortcode
Given I am logged in as a user with the "site_owner" role
    When I go to "node/add/page"
      And I wait for the "#cke_1_top" element to appear
      And I fill in "Title" with "My Box Shortcode"
      And I press "Box Shortcode Generator"
      And I fill in "Title (optional)" with "Box Shortcode"
      And I fill in "Box Text" with "Box Shortcode Text"
      And I select "black" from "Box Color"
      And I select "right" from "Float"
And I press "OK"
And I press "Save"
    #Then I should see "Box Shortcode"
      #And I should see "Box Shortcode Text"
      #And I should see a ".cu-box.box-black.float-right.box-style-filled" element

 @javascript
  Scenario: A site owner should be able to add a countup shortcode
 Given I am logged in as a user with the "site_owner" role
    When I go to "node/add/page"
      And I wait for the "#cke_1_top" element to appear
      And I fill in "Title" with "Countup Shortcode"
      And I follow "Disable rich-text"
      And I fill in "Body" with "[countup]3000[/countup]"
And I press "Save"
      And I wait 5 seconds
    Then I should see "3000"
      And I should not see "[countup]3000[/countup]"
