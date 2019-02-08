  @social_media @twitter
  Feature: Twitter Feed Creation Feature
 Test creation and editing of Twitter Feed Block

  Scenario: Create a Twitter Feed Block
  Given I am logged in as a user with the "site_owner" role
  And I am on "block/add/twitter-block"
  And I fill in "Label" with "Twitter Block Label"
  And I fill in "Title" with "Twitter Block Title"
  And I fill in "Twitter User Name" with "cuboulder"
  And I fill in "Number of Tweets" with "7"
  And I select "Dark" from "Style"
  And I press "Save"
  Then I should see "Twitter Block Title"
  And I should see "Tweets by @cuboulder"
  # And print last response
  #And The "iframe" element should have "twitter-timeline twitter-timeline-rendered" in the "class" attribute

#  And The "iframe" element should have "//www.facebook.com/plugins/likebox.php?href=https%3A%2F%2Fwww.facebook.com%2Fcuboulder&colorscheme=light&height=560&show_faces=false&border_color&stream=true&header=false&appId=137301796349387" in the "src" attribute

Scenario: An EditOnly can edit an Facebook Activity Block
Given I am logged in as a user with the "edit_only" role
And am on "block/twitter-block-label/view"
Then I should see the link "Edit Block"
And I follow "Edit Block"
Then I should see "Edit Twitter Block: Twitter Block Label"
And I should not see "Delete"
