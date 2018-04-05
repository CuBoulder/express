@settings 
Feature: The Settings page lists the settings for all the enabled bundles
In order to test all the settings on a Web Express site
An authenticated user with the appropriate role
Should see the settings for all enabled core bundles

@api
Scenario Outline: A user with the appropriate role can access the Settings page and its links
  Given I am logged in as a user with the <role> role
  And I go to "admin/settings"
  # I SEE ALL THE TYPES OF SETTINGS
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
  
   Examples:
    | role            | message             |
    | site_owner      | "Create Basic page" |
    | administrator   | "Create Basic page" |
    | developer       | "Create Basic page" |

@api
Scenario Outline: All the bundles are enabled
  Given I am logged in as a user with the <role> role
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
  
   Examples:
    | role            | message             |
    | edit_my_content | "Access Denied"     |
    | content_editor  | "Create Basic page" |
    | site_owner      | "Create Basic page" |
    | administrator   | "Create Basic page" |
    | developer       | "Create Basic page" |
    
