@social_media @social_links
Feature: Social Links Creation Feature
 Test creation and editing of social link beans.

Scenario: Create a Social Links Block
Given  I am logged in as a user with the "site_editor" role
And I am on "block/add/social-links"
And I fill in "Label" with "New Social Links Label"
And I fill in "Title" with "New Social Links Title"
And I select "facebook" from "field_social_links_collection[und][0][field_social_link_type][und]"
And I fill in "field_social_links_collection[und][0][field_social_link_url][und][0][url]" with "https://www.facebook.com/cuboulder"
And I press "Add another item"
# And I wait for AJAX
And I select "twitter" from "edit-field-social-links-collection-und-1-field-social-link-type-und"
And I fill in "edit-field-social-links-collection-und-1-field-social-link-url-und-0-url" with "https://twitter.com/cuboulder"
And I press "Save"
Then I should see "New Social Links Title"
And I should see the link "Facebook"
And I should see the link "Twitter"

Scenario: An EditOnly can edit an Social Links Block
Given I am logged in as a user with the "edit_only" role
And am on "block/new-social-links-label/view"
Then I should see the link "Edit Block"
And I follow "Edit Block"
Then I should see "Edit Social Links: New Social Links Label"

