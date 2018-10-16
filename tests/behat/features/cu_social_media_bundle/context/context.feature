  @social_media
  Feature: Context for the Social Media Bundle

@context @contextreactions
Scenario: Social Media Share links are added to Context Reactions
Given  I am logged in as a user with the "site_owner" role
  And I go to "admin/structure/context/add"
When I select "Social media share links" from "edit-reactions-selector"
