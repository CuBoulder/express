@api @settings
Feature: Web Express bundles its features into three types: Core, Add-on and Request
In order to simplify the features of a site
An authenticated user with the proper role
Should see bundles of features in three categories

#NOTE: PAGE ACCESS PERMISSIONS ARE TESTED IN ENABLINGBUNDLES.FEATURE

# CORE BUNDLES
Scenario Outline: Core bundles
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/bundles/list"
  Then I should see "Advanced Content"
   And I should see "Advanced Design"
   And I should see "Advanced Layout"
   And I should see "Feeds"
   And I should see "Forms"
   And I should see "News and Articles"
   And I should see "People"
   And I should see "Photo Gallery"
   And I should see "Publication"
   And I should see "Search Engine Optimization"
   And I should see "Social Media"
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 


# ADD-ON BUNDLES
Scenario Outline: Add-on bundles
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/bundles/list/addon"
  Then I should see "
   And I should see "
   And I should see "
   And I should see "
   And I should see "
   And I should see "
   And I should see "
   And I should see "
   And I should see "
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 
    
# ADD-ON BUNDLES
Scenario Outline: Core bundles
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/bundles/list/addon"
  Then I should see "
   And I should see "
   And I should see "
   And I should see "
   And I should see "
   And I should see "
   And I should see "
   And I should see "
   And I should see "
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

    
 @api 
Scenario Outline: CEs and EMCs should not be able to access the Bundle Requeset page
Given I am logged in as a user with the <role> role
And am on "admin/settings/bundles/list/request"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
