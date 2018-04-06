@settings
Feature: The Settings page lists the configuration options for all the enabled bundles
When I am on the admin/settings page
As a user with the proper role
I should be able to set the site name, enable bundles and other configurations as defined

@api 
Scenario Outline: A user with the appropriate role can access the Settings page and its links
  Given  I am logged in as a user with the <role> role
  When I go to "admin/settings"
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
      | role           |
      | site_owner     |
      | administrator  |
      | developer      |
      
@api @meonly
Scenario: Content Editors cannot set Site Configs; they can only Clear Cache
Given  I am logged in as a user with the "content_editor" role
When I go to "admin/settings"
Then I should not see "Site Configurations"
And I should not see "URL Management"
 # HIDING FOR NOW AS FORMS IS IN FLUX And I should not see "Forms"
  And I should not see "Social Media"
 # SEARCH IS UBIQUITOUS And I should not see "Search"
  And I should not see "News"
  And I should not see "People"
  And I should not see "Advanced Content"
  And I should not see "Feeds"
  And I should not see "Search Engine Optimization"
   # CONTENT EDITOR CAN ONLY CLEAR CACHE
  And I should see "Cache"
      
@api 
Scenario: EMCs cannot access the Site Settings page
  Given  I am logged in as a user with the "edit_my_content" role
  When I go to "admin/settings"
  Then I should see "Access denied"
    
@api 
Scenario: An anonymous user cannot access the Site Settings page
 When I go to "admin/settings"
 Then I should see "Access denied"
