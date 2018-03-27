@AdvContentBundle 
Feature: the Video Reveal block
In order to create a video block with a still cover
As an authenticated user
I should be able to access and use the Video Reveal Block
  
@api 
Scenario Outline: An authenticated user should be able to access the form for adding a video reveal block
  Given  I am logged in as a user with the <role> role
  When I go to "block/add/video-reveal"
  Then I should see <message>

  Examples:
  | role            | message         |
  | edit_my_content | "Access denied" |
  | content_editor  | "Create Video Reveal block" |
  | site_owner      | "Create Video Reveal block" |
  | administrator   | "Create Video Reveal block" |
  | developer       | "Create Video Reveal block" |
  
@api 
Scenario: An anonymous user should not be able to access the form
  Given I go to "block/add/video-reveal"
  Then I should see "Access denied"
