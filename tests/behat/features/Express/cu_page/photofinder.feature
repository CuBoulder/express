#   GOUTTE DRIVER: REMOVE JAVASCRIPT TAG 
#   SELENIUM DRIVER: ADD JAVASCRIPT TAG 

# TO INCLUDE BODY CONTENT
# THIS NEXT LINE IS NECESSARY FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
# And I follow "Disable rich-text"
# And fill in "Body" with "Little cakes with frosting"

# NOTE: IT IS NECESSARY TO EDIT THE NODE TO VERIFY IMAGE UPLOAD CUZ GOUTTE THINKS IT CAN FIND THE IMAGES WHEN IT CAN NOT
# SUCCESSFUL TESTS ARE MARKED

@photofinder 
Feature: Testing Photo Uploads of Goutte Driver and Seleniium Driver
When testing content creation
As an authenticated user
Travis should be able to find assets such as files and photos

@api @javascript
# cupcakes.jpg 
Scenario: A graphic can be attached to a page node (Goutte success)
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes1"
# ENTER ALT TEXT AND PAUSE TO WATCH SAUCELABS
And I fill in "edit-field-photo-und-0-alt" with "Lavender frosting"
And I wait 5 seconds
And I attach the file "cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I press "edit-submit"
Then I should see "Cupcakes1"
And I follow "Edit"
Then I should see "File information"
And I should see "ralphie.jpg"
And the "edit-field-photo-und-0-alt" element should have "Lavender frosting" in the "value" element

@api 
# ../cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes2"
# ENTER ALT TEXT AND PAUSE TO WATCH SAUCELABS
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I wait 5 seconds
And I attach the file "../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I press "edit-submit"
Then I should see "Cupcakes2"
And I follow "Edit"
Then I should see "File information"
And I should see "cupcakes.jpg"
And the "edit-field-photo-und-0-alt" element should have "Lavender and lemony goodness" in the "value" element

@api 
# ../../cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes3"
# ENTER ALT TEXT AND PAUSE TO WATCH SAUCELABS
And I fill in "edit-field-photo-und-0-alt" with "Lemon cakes"
And I wait 5 seconds
And I attach the file "../../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I press "edit-submit"
Then I should see "Cupcakes3"
And I follow "Edit"
Then I should see "File information"
And I should see "castle.jpg"
And the "edit-field-photo-und-0-alt" element should have "Lemon cakes" in the "value" element

@api 
# ../../../cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes4"
# ENTER ALT TEXT AND PAUSE TO WATCH SAUCELABS
And I fill in "edit-field-photo-und-0-alt" with "piles of frosting"
And I wait 5 seconds
And I attach the file "../../../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I press "edit-submit"
Then I should see "Cupcakes4"
And I follow "Edit"
Then I should see "File information"
And I should see "cupcakes.jpg"
And the "edit-field-photo-und-0-alt" element should have "piles of frosting" in the "value" element

@api 
# ../../../../cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes5"
# ENTER ALT TEXT AND PAUSE TO WATCH SAUCELABS
And I fill in "edit-field-photo-und-0-alt" with "purple and yellow"
And I wait 5 seconds
And I attach the file "../../../../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I press "edit-submit"
Then I should see "Cupcakes5"
And I follow "Edit"
Then I should see "File information"
And I should see "cupcakes.jpg"
And the "edit-field-photo-und-0-alt" element should have "purple and yellow" in the "value" element

@api 
# assets/cupcakes.jpg
Scenario: A graphic can be attached to a page node (Goutte success)
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes6"
# ENTER ALT TEXT AND PAUSE TO WATCH SAUCELABS
And I fill in "edit-field-photo-und-0-alt" with "Lavender lemon"
And I wait 5 seconds
And I attach the file "assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I press "edit-submit"
Then I should see "Cupcakes6"
And I follow "Edit"
Then I should see "File information"
And I should see "cupcakes.jpg"
And the "edit-field-photo-und-0-alt" element should have "Lavender lemon" in the "value" element

@api 
# ../assets/cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes7"
# ENTER ALT TEXT AND PAUSE TO WATCH SAUCELABS
And I fill in "edit-field-photo-und-0-alt" with "delicious little cupcakes"
And I wait 5 seconds
And I attach the file "../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I press "edit-submit"
Then I should see "Cupcakes7"
And I follow "Edit"
Then I should see "File information"
And I should see "cupcakes.jpg"
And the "edit-field-photo-und-0-alt" element should have "delicious little cupcakes" in the "value" element

@api 
# ../../assets/cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes8"
# ENTER ALT TEXT AND PAUSE TO WATCH SAUCELABS
And I fill in "edit-field-photo-und-0-alt" with "candy sprinkles"
And I wait 5 seconds
And I attach the file "../../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I press "edit-submit"
Then I should see "Cupcakes8"
And I follow "Edit"
Then I should see "File information"
And I should see "cupcakes.jpg"
And the "edit-field-photo-und-0-alt" element should have "candy sprinkles" in the "value" element

@api 
# ../../../assets/cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes9"
# ENTER ALT TEXT AND PAUSE TO WATCH SAUCELABS
And I fill in "edit-field-photo-und-0-alt" with "happy birthday"
And I wait 5 seconds
And I attach the file "../../../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I press "edit-submit"
Then I should see "Cupcakes9"
And I follow "Edit"
Then I should see "File information"
And I should see "cupcakes.jpg"
And the "edit-field-photo-und-0-alt" element should have "happy birthday" in the "value" element

@api 
# ../../../../assets/cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes10"
# ENTER ALT TEXT AND PAUSE TO WATCH SAUCELABS
And I fill in "edit-field-photo-und-0-alt" with "sweet little cakes"
And I wait 5 seconds
And I attach the file "../../../../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I press "edit-submit"
Then I should see "Cupcakes10"
And I follow "Edit"
Then I should see "File information"
And I should see "cupcakes.jpg"
And the "edit-field-photo-und-0-alt" element should have "sweet little cakes" in the "value" element

