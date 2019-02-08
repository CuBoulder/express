@social_media
Feature: Facebook Like Creation Feature
 Tests creation and editing of Facebook like beans.

Scenario: Create an Facebook Like Block.
  Given  I am logged in as a user with the "site_editor" role
    And I am on "block/add/facebook-like-button"
    And I fill in "Label" with "Facebook Like Label"
    And I fill in "Title" with "Facebook Like Title"
    And I fill in "field_fb_url[und][0][url]" with "https://www.facebook.com/cuboulder"
    And I select "true" from "field_fb_like_faces[und]"
    And I select "recommend" from "field_fb_verb[und]"
    And I press "Save"
  Then I should see "Facebook Like Title"
    And The "iframe" element should have "//www.facebook.com/plugins/like.php?href=https%3A%2F%2Fwww.facebook.com%2Fcuboulder&send=false&layout=standard&show_faces=true&action=recommend&colorscheme=light&font&height=80&appId=137301796349387" in the "src" attribute

Scenario: An EditOnly can edit an Facebook Like Block
Given I am logged in as a user with the "edit_only" role
And am on "block/facebook-like-label/view"
Then I should see the link "Edit Block"
And I follow "Edit Block"
Then I should see "Edit Facebook Like Button: Facebook Like Label"
Then I should not see "Delete"
