@settings
Feature: Site Verification allows for improved Google Search results
In order to create verification files for Google verification
An authenticated user with the proper role
Should be able to verify their site

#NOTE: SHOULDN'T THIS BE IN SEO BUNDLE INSTEAD?

@api
Scenario Outline: only Devs, Admins, SOs and ConMgrs can view the Site Verification page
Given I am logged in as a user with the <role> role
  And am on "admin/config/search/verifications"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Verifications" |
| administrator    | "Verifications" |
| site_owner       | "Verifications" |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "Access denied" |
| edit_only        | "Access denied" |
| access_manager   | "Access denied" |
| configuration_manager | "Verifications" |

Scenario Outline:the Site Verification page is populated with three links
  Given I am logged in as a user with the "site_owner" role
  And am on "admin/config/search/verifications"
  Then I should see "Verifications"
  And I should see the link "Add verification"
  And I should see the link "sort by Engine"
  And I should see the link "sort by Meta tag"
  And I should see the link "sort by File"

# SOME ROLES CAN NOT ADD VERIFICATION INFORMATION
@api 
Scenario Outline: only Devs, Admins, SOs and ConMgrs can add Site Verification info
Given I am logged in as a user with the <role> role
And am on "admin/config/search/verifications/add"
Then I should see <message>

Examples:
| role             | message |
| developer        | "Search engine" |
| administrator    | "Search engine" |
| site_owner       | "Search engine" |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "Access denied" |
| edit_only        | "Access denied" |
| access_manager   | "Access denied" |
| configuration_manager | "Search engine" |
    
@api 
Scenario: An anonymous user should not be able to verify the site
  When I am on "admin/config/search/verifications"
  Then I should see "Access denied"
  And I go to "admin/config/search/verifications/add"
  Then I should see "Access denied"
  
@api @testing_frontpage
Scenario Outline: When Site Verification is populated, it shows up in the homepage code
  Given I am logged in as a user with the "site_owner" role
  And am on "admin/config/search/verifications/add"
    And I select "google" from "edit-engine"
    And I press "edit-next"
   And I fill in "edit-meta" with "<meta name=\"site-verify\" content=\"abcdefg123456\" >"
   And I press "edit-submit"
   Then I should see "Verification saved"
   And I go to "/"
   Then the response should contain "content=\"abcdefg123456\""
   
   
