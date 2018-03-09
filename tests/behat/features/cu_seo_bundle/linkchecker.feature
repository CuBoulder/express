Feature: Linkchecker Features
  Create different configurations of Photo Galleries.

  @linkchecker @seo @javascript
  Scenario: Analyze links.
    Given  I am logged in as a user with the "site_owner" role
      And am on "admin/settings/seo/linkchecker-analyze"
      And I press "Analyze content for links"
      And I wait 5 seconds
    Then I should see "blocks have been scanned"
