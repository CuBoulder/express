#   GOUTTE DRIVER: REMOVE JAVASCRIPT TAG 
#   SELENIUM DRIVER: ADD JAVASCRIPT TAG 

# TO INCLUDE BODY CONTENT
# THIS NEXT LINE IS NECESSARY FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
# And I follow "Disable rich-text"
# And fill in "Body" with "Little cakes with frosting"

@photofinder 
Feature: Testing Photo Uploads of Goutte Driver and Seleniium Driver
When testing content creation
As an authenticated user
Travis should be able to find assets such as files and photos

@api 
# cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes1"
And I attach the file "cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes1"
And I follow "Edit"
Then I should see "File information"
And I should see "castle.jpg"
And the "edit-field-photo-und-0-alt" element should have "Lavender and lemony goodness" in the "value" element

@api 
# ../cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes2"
And I attach the file "../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes2"
And I follow "Edit"
Then I should see "File information"
And I should see "castle.jpg"
And the "edit-field-photo-und-0-alt" element should have "Lavender and lemony goodness" in the "value" element

@api 
# ../../cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes3"
And I attach the file "../../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes3"
And I follow "Edit"
Then I should see "File information"
And I should see "castle.jpg"
And the "edit-field-photo-und-0-alt" element should have "Lavender and lemony goodness" in the "value" element

@api 
# ../../../cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes4"
And I attach the file "../../../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes4"
And I follow "Edit"
Then I should see "File information"
And I should see "castle.jpg"
And the "edit-field-photo-und-0-alt" element should have "Lavender and lemony goodness" in the "value" element

@api 
# ../../../../cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes5"
And I attach the file "../../../../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes5"
And I follow "Edit"
Then I should see "File information"
And I should see "castle.jpg"
And the "edit-field-photo-und-0-alt" element should have "Lavender and lemony goodness" in the "value" element

@api 
# assets/cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes6"
And I attach the file "assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes6"
And I follow "Edit"
Then I should see "File information"
And I should see "castle.jpg"
And the "edit-field-photo-und-0-alt" element should have "Lavender and lemony goodness" in the "value" element

@api 
# ../assets/cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes7"
And I attach the file "../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes7"
And I follow "Edit"
Then I should see "File information"
And I should see "castle.jpg"
And the "edit-field-photo-und-0-alt" element should have "Lavender and lemony goodness" in the "value" element

@api 
# ../../assets/cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes8"
And I attach the file "../../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes8"
And I follow "Edit"
Then I should see "File information"
And I should see "castle.jpg"
And the "edit-field-photo-und-0-alt" element should have "Lavender and lemony goodness" in the "value" element

@api 
# ../../../assets/cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes9"
And I attach the file "../../../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes9"
And I follow "Edit"
Then I should see "File information"
And I should see "castle.jpg"
And the "edit-field-photo-und-0-alt" element should have "Lavender and lemony goodness" in the "value" element

@api 
# ../../../../assets/cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes10"
And I attach the file "../../../../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes10"
And I follow "Edit"
Then I should see "File information"
And I should see "castle.jpg"
And the "edit-field-photo-und-0-alt" element should have "Lavender and lemony goodness" in the "value" element

