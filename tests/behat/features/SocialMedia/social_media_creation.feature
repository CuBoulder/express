Feature: Event Blocks Creation
  Create different configurations of Event Calendar Grids and Blocks.

  @api @social_media
  Scenario: Create a Social Links Block.
    Given I am logged in as a user with the "content_editor" role
      And I am on "block/add/social-links"
      And I fill in "Label" with "New Social Links Block"
      And I fill in "Title" with "Social Links Block Title"
      And I select "facebook" from "field_social_links_collection[und][0][field_social_link_type][und]"
      And I fill in "field_social_links_collection[und][0][field_social_link_url][und][0][url]" with "https://www.facebook.com/cuboulder"
      And I press the "field_social_links_collection_add_more" button
      And I select "twitter" from "field_social_links_collection[und][1][field_social_link_type][und]"
      And I fill in "field_social_links_collection[und][1][field_social_link_url][und][0][url]" with "https://twitter.com/cuboulder"
      And I press "Save"
    Then I should see "Social Links Block Title"
      And I should see the link "Facebook"
      And I should see the link "Twitter"

  @api @social_media
  Scenario: Create an Facebook Activity Block.
    Given I am logged in as a user with the "content_editor" role
      And I am on "block/add/facebook-activity"
      And I fill in "Label" with "Facebook Activity Label"
      And I fill in "Title" with "Facebook Activity Block"
      And I fill in "field_fb_url[und][0][url]" with "https://www.facebook.com/cuboulder"
      And I select "false" from "field_fb_like_faces[und]"
      And I press "Save"
    Then I should see "Facebook Activity Block"
      And The "iframe" element should have "//www.facebook.com/plugins/likebox.php?href=https%3A%2F%2Fwww.facebook.com%2Fcuboulder&colorscheme=light&height=560&show_faces=false&border_color&stream=true&header=false&appId=137301796349387" in the "src" attribute

  @api @social_media
  Scenario: Create an Facebook Like Block.
    Given I am logged in as a user with the "content_editor" role
      And I am on "block/add/facebook-like-button"
      And I fill in "Label" with "Facebook Activity Label"
      And I fill in "Title" with "Facebook Activity Block Title"
      And I fill in "field_fb_url[und][0][url]" with "https://www.facebook.com/cuboulder"
      And I select "true" from "field_fb_like_faces[und]"
      And I select "recommend" from "field_fb_verb[und]"
      And I press "Save"
    Then I should see "Facebook Activity Block Title"
      And The "iframe" element should have "//www.facebook.com/plugins/like.php?href=https%3A%2F%2Fwww.facebook.com%2Fcuboulder&send=false&layout=standard&show_faces=true&action=recommend&colorscheme=light&font&height=80&appId=137301796349387" in the "src" attribute

  @api @social_media @javascript
  Scenario: Create an Facebook Like Block.
    Given I am logged in as a user with the "content_editor" role
    And I am on "block/add/twitter-block"
    And I fill in "Label" with "Twitter Block Label"
    And I fill in "Title" with "Twitter Block Title"
    And I fill in "Twitter User Name" with "cuboulder"
    And I fill in "Number of Tweets" with "7"
    And I select "dark" from "field_twitter_style[und]"
    And I press "Save"
    Then I should see "Twitter Block Title"
    And The "iframe" element should have "twitter-timeline twitter-timeline-rendered" in the "class" attribute