@AdvDesign @abcdefg
Feature: Font Awesome Icons in menus and block titles
In order to add visual interest to my site
As an authenticated user
I should be able to add icons to menus and block titles

# THE FOLLOWING FAILS; CANT TARGET THAT LITTLE BLOCK CONFIGURE WIDGET SO TRYING ANOTHER WAY
@javascript 
# Scenario: An authenticated user can add an icon to a block title
# Given I am logged in as a user with the "site_owner" role
# CREATE A BASIC PAGE
# And I am on "node/add/page"
 # And fill in "edit-title" with "My Page"
 # And I follow "Disable rich-text"
 # And fill in "Body" with "Lorem ipsum dolor sit amet"
 # And I press "edit-submit"
# ADD A TEXT BLOCK
#  And I follow "Edit Layout"
#  And I select "Text Block" from "edit-field-sidebar-second-und-actions-bundle"
#  And I wait for AJAX
#  And I fill in "edit-field-sidebar-second-und-form-label" with "ABC Text Block Label"
#  And I fill in "edit-field-sidebar-second-und-form-title" with "ABC Text Block Title"
#  And I follow "Disable rich-text"
#   And I fill in "Body" with "A is for Apple"
#   And I press "Create block"
#   And I press "Update layout"
 #  Then I should see "A is for Apple"
  # MIGHT WORK And I click the ".express_block_designer' element (A LIST ITEM ELEMENT)
 # And I follow ".contextual-links-trigger"
  # ELEMENT NOT VISIBLE And I click the "a" element with "contextual-links-trigger" for "class"  
 # And I wait for AJAX
 #  And I follow "Block Designer"
  # Then I should see "Block Designer: \'ABC Text Block Label\'"
  #And I select "fa-apple" from "icon"
 # And I press "edit-submit"
 #  Then the response should contain "class=\"fa fa-apple\""
   
   
Scenario: An authenticated user can add an icon to a block title
Given I am logged in as a user with the "site_owner" role
# CREATE A BLOCK
 And I am on #block/add/block
 
Scenario: An authenticated user can add an icon to the main menu
Given I am logged in as a user with the "site_owner" role
And I am on "admin/structure/menu/manage/main-menu"
And I fill in "edit-additem-title" with "Academics"
And I press "edit-submit" 
Then the "edit-link-title" field should contain "Academics"
And I fill in "edit-link-path" with "https://www.colorado.edu/academics"
And I select "fa-bug" from "icon"
And I press "Save"
And I go to "/"
Then the response should contain "class=\"fa fa-fw fa-bug\""


   
 
