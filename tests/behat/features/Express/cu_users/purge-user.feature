@users @purge-user
Feature: Purge Users
  Users can be programmatically purged.

  Scenario: Create user to be purged.
    Given I am logged in as a site_owner
    When I go to "test-create-user/foo_bar/site_editor/FooBar"
    Then I should see "Created User {name: 'foo_bar', roles: 'authenticated user,site_editor', realname: 'FooBar'."\

  Scenario: Create content for user to be purged.
    Given I am logged in as a site_owner
    When I go to "test-create-content/foo_bar"
    Then I should see "Created content for 'foo_bar'."

  Scenario: Purge user and check reassigned content.
    Given I am logged in as a site_owner
    When I go to "test-purge-user/foo_bar/identikey"
    Then I should see "Purging User {foo_bar} - Successfully completed purge."
    # Check page content is reassigned to other users.
    When I go to "admin/content?title=Testy+Page&type=All&status=All&realname=foo_bar"
    Then I should see "No content available."
    When I go to "admin/content?title=Testy+Page&type=All&status=All&realname=site_owner"
    Then I should not see "No content available."
    # Check block content is reassigned to other users.
    When I go to "admin/content/blocks?title=Testy+Text&label=&type=All&realname=foo_bar"
    Then I should see "No content available."
    When I go to "admin/content/blocks?title=Testy+Text&label=&type=All&realname=site_owner"
    Then I should not see "No content available."
