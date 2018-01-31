Feature: WYSIWYG Access Feature
When I login to the website
As a content editor, site owner, administrator or developer
I should be able to access the functionality of the WYSIWYG editor

  @api @wysiwyg @javascript
  Scenario Outline: An authenticated user should have WYSIWYG selected as the the default text format
    Given  I am logged in as a user with the <role> role
    When I go to "node/add/page"
      And I wait for the "cke_1_top" element to appear
    Then I should see "Bold"

    Examples:
      | role           |
      | content_editor |
      | site_owner     |
      | administrator  |
      | developer      |


  @api @wysiwyg @javascript
  Scenario Outline: An authenticated user should have all the WYSIWYG shortcode and other buttons available
    Given I am logged in as a user with the <role> role
    When I go to "node/add/page"
      And I wait for the "cke_1_top" element to appear
    Then I should see "Button Shortcode Generator"
      And I should see "Image Caption Shortcode Generator"
      And I should see "Image Caption Shortcode Generator"
      And I should see "Icon Shortcode Generator"
      And I should see "Give Button Shortcode Generator"
      And I should see "Expand Content Shortcode Generator"
      And I should see "Map Shortcode Generator"
      And I should see "Box Shortcode Generator"
      And I should see "Video Shortcode Generator"
      And I should see "Link"

    Examples:
      | role           |
      | content_editor |
      | site_owner     |
      | administrator  |
      | developer      |
