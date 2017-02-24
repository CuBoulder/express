Feature: Metatags
  Test different ways you can alter metatags.

  @api @seo @metatags @FIT-2490
  Scenario: The page title metatag should correctly render.
    Given  CU - I am logged in as a user with the "site_owner" role
    When I go to "node/add/page"
      And I fill in "edit-title" with "Metatag Title Page"
      And I fill in "edit-metatags-und-title-value" with "[node:title] | [current-page:pager][site:name] | Added Title"
      And I press the "Save" button
    Then the "title" element should contain "Metatag Title Page | University of Colorado Boulder Fail | Added Title | University of Colorado Boulder"
