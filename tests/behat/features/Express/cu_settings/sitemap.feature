@settings @retestus @javascript
Feature: an XML Site Map improves Search Engine results
In order to communicate the site layout to search engines
An authenticated user with the proper role
Should be able to update the Web Express XML site map

#SOME ROLES CAN ACCESS SITE MAP SETTINGS
@api
Scenario Outline: Devs, Admins and SOs can access the sitemap page
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/seo/xmlsitemap"
  Then I should see "sitemap.xml"
  And I should see "Update Sitemap"
  And I should see "Include Menus"
  And the checkbox "edit-options-menu-footer-menu" should be checked
  And the checkbox "edit-options-main-menu" should be checked
  And the checkbox "edit-options-menu-secondary-menu" should be checked
  
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 
    
    
#SOME ROLES CAN UPDATE AND CHANGE SITE MAP SETTINGS
@api
Scenario Outline: Devs, Admins and SOs can update the sitemap
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/seo/xmlsitemap"
  And I press "edit-submit"
  And I wait 20 seconds
  Then I should see "The sitemap links were rebuilt."
  And I press "edit-submit--2"
  And I wait 20 seconds
  Then I should see "Menu options have been updated for sitemap"
  
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

# SOME ROLES CAN NOT ACCESS SITE MAP SETTINGS
@api 
Scenario Outline: CEs and EMCs should not be able to update the sitemap
Given I am logged in as a user with the <role> role
And am on "admin/settings/seo/xmlsitemap"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
 
@api 
Scenario: An anonymous user should not be able to update the sitemap
  When I am on "admin/settings/seo/xmlsitemap"
  Then I should see "Access denied"
