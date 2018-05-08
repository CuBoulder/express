@blocks
Feature: Hero Unit Block
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete a hero unit block


Scenario Outline: An authenticated user should be able to access the form for adding a hero unit block
  Given  I am logged in as a user with the <role> role
  When I go to "block/add/hero-unit"
  Then I should see <message>

    Examples:
    | role            | message             |
    | edit_my_content | "Access Denied"     |
    | content_editor  | "Create Hero Unit block" |
    | site_owner      | "Create Hero Unit block" |
    | administrator   | "Create Hero Unit block" |
    | developer       | "Create Hero Unit block" |


Scenario: An anonymous user should not be able to access the form for adding a hero unit block
  When I am on "block/add/hero-unit"
  Then I should see "Access denied"


Scenario: A basic Hero Unit block can be created
Given I am logged in as a user with the "site_owner" role
 And I am on "block/add/hero-unit"
 And fill in "edit-label" with "New Hero Unit"
 And fill in "edit-title" with "Hero Unit Title"
 And I fill in "edit-field-hero-unit-headline-und-0-value" with "Important Headline"
 And I fill in "edit-field-hero-unit-text-und-0-value" with "Learn more about our program"
 And I press "Save"
 Then I should see "Hero Unit Title"
 And I should see "Learn more about our program"
 

Scenario: A link, a graphic and an overlay can be added to Hero Unit block
Given I am logged in as a user with the "site_owner" role
 And I am on "block/add/hero-unit"
 And fill in "edit-label" with "My Hero Unit"
 And fill in "edit-title" with "A New Hero Unit"
 And I fill in "edit-field-hero-unit-headline-und-0-value" with "Important News"
 And I fill in "edit-field-hero-unit-text-und-0-value" with "Read More About It"
 And I fill in "edit-field-hero-unit-link-und-0-title" with "Click Here"
 And I fill in "edit-field-hero-unit-link-und-0-url" with "node/1"
 And I attach the file "ralphie.jpg" to "edit-field-hero-unit-image-und-0-upload"
 And I check "edit-field-hero-unit-overlay-und"
 And I press "Save"
 Then I should see "A New Hero Unit"
 And I should see "Important News"
 And I should see the link "Click Here"
 And the response should contain "hero-unit-overlay"
