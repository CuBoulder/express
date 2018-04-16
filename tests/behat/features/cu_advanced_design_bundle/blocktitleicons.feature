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
   
  
 
 @api @AdvDesign
Scenario: An authenticated user can add an icon to a block title
Given I am logged in as a user with the "site_owner" role
# CREATE A TEXT BLOCK
 And I am on "block/add/block"
 And I fill in "edit-label" with "ABC Text Block Label"
 And fill in "edit-title" with "ABC Text Block Title"
And I fill in "Body" with "A is for Apple"
 And I press "Save"
 # ATTACH AN ICON TO THE BLOCK
And I follow "Block Designer"
And I select "fa-apple" from "icon"
 And I press "edit-submit"
 Then I should see "Block Desiger settings have been saved."
 # CREATE BASIC PAGE
Then I go to "node/add/page"
  And fill in "edit-title" with "About Apples"
  And fill in "Body" with "Apple blossom is the state flower of Michigan."
  And I press "edit-submit"
Then I should see "About Apples"
# ADD BLOCK TO PAGE
And I follow "Edit layout"
And I press "edit-field-sidebar-second-und-actions-ief-add-existing"
And I fill in "edit-field-sidebar-second-und-form-entity-id" with "ABC Text Block Title"
And I wait 5 seconds
And I press "Add block"
And I press "Update layout"
Then I should see "ABC Text Block Title"
Then the response should contain "class=\"fa fa-apple\""
