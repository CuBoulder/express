#   GOUTTE DRIVER: REMOVE JAVASCRIPT TAG AND HIDE THE 'FOLLOW DISABLE RICH TEXT' LINE
#   SELENIUM DRIVER: ADD JAVASCRIPT TAG AND UNHIDE THE 'FOLLOW DISABLE RICH TEXT' LINE

@photofinder @javascript
Feature: Testing Photo Uploads of Goutte Driver and Seleniium Driver
When I create a Basic Page
As an authenticated user
I should be able to upload and place a photo


@api 
# cupcakes.jpg
Scenario: A graphic can be uploaded and inserted into a page; checking for an insert element with javascript
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
# THIS NEXT LINE IS NECESSARY FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
And I follow "Disable rich-text"
And fill in "Body" with "Little cakes with frosting"
And I attach the file "cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"
And I should see "Little cakes with frosting"

@api 
# ../cupcakes.jpg
Scenario: A graphic can be uploaded and inserted into a page; checking for an insert element with javascript
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
# THIS NEXT LINE IS NECESSARY FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
And I follow "Disable rich-text"
And fill in "Body" with "Little cakes with frosting"
And I attach the file "../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"
And I should see "Little cakes with frosting"

@api 
# ../../cupcakes.jpg
Scenario: A graphic can be uploaded and inserted into a page; checking for an insert element with javascript
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
# THIS NEXT LINE IS NECESSARY FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
And I follow "Disable rich-text"
And fill in "Body" with "Little cakes with frosting"
And I attach the file "../../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"
And I should see "Little cakes with frosting"

@api 
# ../../../cupcakes.jpg
Scenario: A graphic can be uploaded and inserted into a page; checking for an insert element with javascript
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
# THIS NEXT LINE IS NECESSARY FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
And I follow "Disable rich-text"
And fill in "Body" with "Little cakes with frosting"
And I attach the file "../../../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"
And I should see "Little cakes with frosting"

@api 
# ../../../../cupcakes.jpg
Scenario: A graphic can be uploaded and inserted into a page; checking for an insert element with javascript
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
# THIS NEXT LINE IS NECESSARY FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
And I follow "Disable rich-text"
And fill in "Body" with "Little cakes with frosting"
And I attach the file "../../../../cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"
And I should see "Little cakes with frosting"

@api 
# assets/cupcakes.jpg
Scenario: A graphic can be uploaded and inserted into a page; checking for an insert element with javascript
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
# THIS NEXT LINE IS NECESSARY FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
And I follow "Disable rich-text"
And fill in "Body" with "Little cakes with frosting"
And I attach the file "assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"
And I should see "Little cakes with frosting"

@api 
# ../assets/cupcakes.jpg
Scenario: A graphic can be uploaded and inserted into a page; checking for an insert element with javascript
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
# THIS NEXT LINE IS NECESSARY FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
And I follow "Disable rich-text"
And fill in "Body" with "Little cakes with frosting"
And I attach the file "../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"
And I should see "Little cakes with frosting"

@api 
# ../../assets/cupcakes.jpg
Scenario: A graphic can be uploaded and inserted into a page; checking for an insert element with javascript
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
# THIS NEXT LINE IS NECESSARY FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
And I follow "Disable rich-text"
And fill in "Body" with "Little cakes with frosting"
And I attach the file "../../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"
And I should see "Little cakes with frosting"

@api 
# ../../../assets/cupcakes.jpg
Scenario: A graphic can be uploaded and inserted into a page; checking for an insert element with javascript
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
# THIS NEXT LINE IS NECESSARY FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
And I follow "Disable rich-text"
And fill in "Body" with "Little cakes with frosting"
And I attach the file "../../../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"
And I should see "Little cakes with frosting"

@api 
# ../../../../assets/cupcakes.jpg
Scenario: A graphic can be uploaded and inserted into a page; checking for an insert element with javascript
Given I am logged in as a user with the "site_owner" role
And I am on "node/add/page"
And fill in "edit-title" with "Cupcakes"
# THIS NEXT LINE IS NECESSARY FOR FINDING THE BODY FIELD WHEN JAVASCRIPT TESTING IS ENABLED
And I follow "Disable rich-text"
And fill in "Body" with "Little cakes with frosting"
And I attach the file "../../../../assets/cupcakes.jpg" to "edit-field-photo-und-0-upload"
And I fill in "edit-field-photo-und-0-alt" with "Lavender and lemony goodness"
And I press "edit-submit"
Then I should see "Cupcakes"
And I should see "Little cakes with frosting"

