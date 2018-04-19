@AdvDesign
Feature: Font Awesome Icons in block titles
In order to add visual interest to my site
As an authenticated user
I should be able to attach Font Awesome icons to my block titles

@api @javascript
Scenario: An authenticated user can add an icon to a block title
Given I am logged in as a user with the "site_owner" role
# CREATE A TEXT BLOCK AND ATTACH AN ICON TO IT
And I am on "block/add/block"
And I fill in "edit-label" with "Learn More"
And fill in "edit-title" with "Learn More"
And I follow "Disable rich-text"
And I fill in "Body" with "A is for Apple"
And I press "Save"
# JAVASCRIPT CANNOT FIND And I follow "Block Designer"
And I go to "block/learn-more/design"
And I click the "#edit-icon a.fieldset-title" element
And I select "fa-apple" from "exbd_icon"
And I press "edit-submit"
Then I should see "Block Desiger settings have been saved."
# CREATE A BASIC PAGE
Then I go to "node/add/page"
And fill in "edit-title" with "About Apples"
And I follow "Disable rich-text"
And fill in "Body" with "The apple blossom is the state flower of Michigan."
And I press "edit-submit"
Then I should see "About Apples"

# ADD BLOCK TO PAGE WITH PAGE LAYOUT
#And I follow "Edit Layout"
#And I press "edit-field-sidebar-second-und-actions-ief-add-existing"
#And I fill in "edit-field-sidebar-second-und-form-entity-id" with "Apples Label"
#And I wait 5 seconds
#And I press "Add block" IT WON'T FIND THE DAMN BLOCK
#And I press "edit-submit"
#Then I should see "ABC Text Block Title"

# ADD BLOCK TO PAGE WITH CONTEXT
Then I go to "admin/structure/context/add"
And I fill in "edit-name" with "appleicon"
And I select "path" from "edit-conditions-selector"
And I fill in "edit-conditions-plugins-path-values" with "about-apples"
And I select "block" from "edit-reactions-selector"
And I break
# And I click the "#edit-reactions-plugins-block-selector-block a.fieldset-title" element
And I click the "#edit-reactions-plugins-block-selector-text-block a.fieldset-title" element
And I check "edit-reactions-plugins-block-selector-text-block-checkboxes-bean-learn-more"
And I click the ".context-blockform-regionlabel-sidebar_second a" element
And I press "Save"
Then I should see "appleicon has been created"
# GO CHECK THE PAGE
 And I go to "/about-apples"
 Then I should see "About Apples"
 And I should see "Learn More"
 And the response should contain "class=\"fa fa-apple\""
