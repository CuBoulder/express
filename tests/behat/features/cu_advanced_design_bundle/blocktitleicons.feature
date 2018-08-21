@AdvancedDesign
Feature: Font Awesome Icons in block titles
In order to add visual interest to my site
As an authenticated user
I should be able to attach Font Awesome icons to my block titles

# TESTING NOTE: ATTACHING A BLOCK TO A PAGE IS VERY DIFFICULT WITH BEHAT; IT CAN BE DONE BUT THE
# TEST IS NOT ROBUST - i.e IT'S EASY TO BREAK; SO IT HAS TO BE A HUMAN-RUN TEST, NOT AN AUTOMATED ONE

# JAVASCRIPT TAG IS NECESSARY FOR TEST TO FIND #EDIT-ICON ELEMENt
@javascript
Scenario: An authenticated user can add an icon to a block title
Given I am logged in as a user with the "site_owner" role
And I am on "block/add/block"
# And I fill in "edit-label" with "Apple Info Block"
# And fill in "edit-title" with "Apple Info Block"
And I fill in "Label" with "Apple Info Block"
And fill in "Title" with "Apple Info Block"
And I follow "Disable rich-text"
And I press "Save"
And I go to "block/apple-info-block/design"
And I click the "#edit-icon a.fieldset-title" element
And I select "fa-apple" from "exbd_icon"
And I press "edit-submit"
#YES THE FOLLOWING LINE IS MISSPELLED IN WEB EXPRESS
Then I should see "Block Desiger settings have been saved."
