@AdvDesign
Feature: Font Awesome Icons in block titles
In order to add visual interest to my site
As an authenticated user
I should be able to attach Font Awesome icons to my block titles

# TESTING NOTE: ATTACHING A BLOCK TO A PAGE IS VERY DIFFICULT WITH BEHAT; 
# IT CAN BE DONE BUT THE TEST IS NOT ROBUST; SO IT HAS TO BE A FUNCTIONAL TEST, NOT AN AUTOMATED ONE

@javascript
Scenario: An authenticated user can add an icon to a block title
Given I am logged in as a user with the "site_owner" role

# CREATE A TEXT BLOCK AND ATTACH AN ICON TO IT
And I am on "block/add/block"
And I fill in "edit-label" with "Apple Info Block"
And fill in "edit-title" with "Apple Info Block"
And I follow "Disable rich-text"
And I fill in "Body" with "A is for Apple"
And I press "Save"
And I go to "block/apple-info-block/design"
# SEE IF FOLLOWING BLOCK DESIGNER WORKS
# And I follow "Block Designer" NO IT DOESN'T WORK; CAN'T BE FOUND
And I click the "#edit-icon a.fieldset-title" element
And I select "fa-apple" from "exbd_icon"
And I press "edit-submit"
#YES THE FOLLOWING LINE IS MISSPELLED IN WEB EXPRESS
Then I should see "Block Desiger settings have been saved."

# CREATE A BASIC PAGE
Then I go to "node/add/page"
And fill in "edit-title" with "About Apples"
And I follow "Disable rich-text"
And fill in "Body" with "The apple blossom is the state flower of Michigan."
And I press "edit-submit"
Then I should see "About Apples"

# ADD BLOCK TO PAGE WITH LAYOUT
# Then I follow "Edit Layout"
# And I select "Text Block" from "edit-field-intro-und-actions-bundle--3"
# And I fill in "edit-field-intro-und-form-label" with "Apple Info Block"
# And fill in "edit-field-intro-und-form-title" with "Apple Info Block"
# And I press 'Create block"

# GO CHECK THE PAGE
# And I go to "/about-apples"
# Then I should see "About Apples"
# And I should see "Learn More"
# And the response should contain "fa fa-apple"
# And the response should contain "class=\"exbd-block-icon fa fa-apple\""
