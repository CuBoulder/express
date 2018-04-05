@settings
Feature: Site Verification allows for improved Google Search results
In order to create verification files for Google verification
An authenticated user with the proper role
Should be able to verify their site

#SOME ROLES CAN ACCESS SEO VERIFICATIONS PAGE
@api
Scenario Outline: Devs, Admins and SOs can view the RSS feeds
  Given I am logged in as a user with the <role> role
  And am on "admin/config/search/verifications"
  Then I should see "Verifications"
  And I should see the link "sort by Engine"
  And I should see the link "sort by Meta tag"
  And I should see the link "Add verification"
  
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 


#SOME ROLES CAN ADD VERIFICATION INFORMATION
@api
Scenario Outline: Devs, Admins and SOs create an RSS feed
  Given I am logged in as a user with the <role> role
  And am on "admin/config/search/verifications/add"
    And I select "google" from "edit-engine"
    And I press "edit-next"
   And I fill in "edit-meta" with "<meta name=\"site-verify\" content=\"abcdefg123456\" >"
   And I press "edit-submit"
   Then I should see "Verification saved"
   And I go to "/"
   Then the response should contain "content=\"abcdefg123456\""
  
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 
  
# SOME ROLES CAN NOT ACCESS SEO VERIFICATIONS PAGE
@api 
Scenario Outline: CEs and EMCs should not be able to set site name
Given I am logged in as a user with the <role> role
And am on "admin/config/search/verifications"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
 
 
# SOME ROLES CAN NOT ADD VERIFICATION INFORMATION
@api 
Scenario Outline: CEs and EMCs should not be able to set site name
Given I am logged in as a user with the <role> role
And am on "admin/config/search/verifications/add"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
    
    
 @api 
Scenario: An anonymous user should not be able to verify the site
  When I am on "admin/config/search/verifications"
  Then I should see "Access denied"
  And I go to "admin/config/search/verifications/add"
  Then I should see "Access denied"
