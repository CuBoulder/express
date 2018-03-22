@settings @buildcheck
Feature: The Settings page lists all enabled bundle settings
In order to test all the settings on a Web Express site
An authenticated user with the Site Owner role
Should see the settings for all allowed core bundles

@api
Scenario: All the bundles are enabled
  Given I am logged in as a user with the "site_owner" role
  And I go to "admin/settings"
  Then I should see "Site Configurations"
  And I should see "URL Management"
  And I should see "Cache"
  And I should see "Forms"
  And I should see "Social Media"
  And I should see "Search"
  And I should see "News"
  And I should see "People"
  And I should see "Advanced Content"
  And I should see "Feeds"
  And I should see "Search Engine Optimization"
