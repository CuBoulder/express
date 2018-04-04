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
And fill in "edit-title" with "Cupcakes"
And I attach the file "cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"

@api 
# ../cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
And I attach the file "../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"

@api 
# ../../cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
And I attach the file "../../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"

@api 
# ../../../cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
And I attach the file "../../../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"

@api 
# ../../../../cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
And I attach the file "../../../../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"

@api 
# assets/cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
And I attach the file "assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"

@api 
# ../assets/cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
And I attach the file "../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"

@api 
# ../../assets/cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
And I attach the file "../../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"

@api 
# ../../../assets/cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
And I attach the file "../../../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"

@api 
# ../../../../assets/cupcakes.jpg
Scenario: A graphic can be attached to a page node
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
And I attach the file "../../../../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"

