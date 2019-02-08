  @social_media
  Feature: Facebook Activity Block Creation
  Tests creation and editing of Facebook Activity Blocks.

  Scenario: Create an Facebook Activity Block
  Given  I am logged in as a user with the "site_editor" role
  And I am on "block/add/facebook-activity"
  And I fill in "Label" with "Facebook Activity Label"
  And I fill in "Title" with "Facebook Activity Title"
  And I fill in "field_fb_url[und][0][url]" with "https://www.facebook.com/cuboulder"
  And I select "false" from "field_fb_like_faces[und]"
  And I press "Save"
  Then I should see "Facebook Activity Title"
  And The "iframe" element should have "//www.facebook.com/plugins/likebox.php?href=https%3A%2F%2Fwww.facebook.com%2Fcuboulder&colorscheme=light&height=560&show_faces=false&border_color&stream=true&header=false&appId=137301796349387" in the "src" attribute

Scenario: An EditOnly can edit an Facebook Activity Block
Given I am logged in as a user with the "edit_only" role
And am on "block/facebook-activity-label/view"
Then I should see the link "Edit Block"
And I follow "Edit Block"
Then I should see "Edit Facebook Activity: Facebook Activity Label"
Then I should not see "Delete"
