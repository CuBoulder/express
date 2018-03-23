@seo
Feature: Search Engine Optimization Bundle
  In order to optimize my site content for search engines
  As an authenticated user with the proper role
  I should be able access and edit SEO links and functionality
  
 Scenario Outline: Only Developers can verify that the Google Analytics Settings page has been installed
 Given I am logged is as a user with the <role> role
 When I go to "admin/config/system/googleanalytics"
 Then I should see <message>
 
 Examples:
    | role            | message            |
    | developer       | "General Settings" |
    | administrator   | "Access denied"    |
    | site_owner      | "Access denied"    |
    | content_editor  | "Access denied"    |
    | edit_my_content | "Access denied"    |

#CHECK THAT SEO TAB EXISTS FOR APPROPRIATE USERS
@api 
Scenario Outline: Devs, SOs and CEs are given the SEO tab
Given I am logged in as a user with the <role> role
When I go to "admin/dashboard"
Then I should see "User"
And I should see "SEO"
And I should see an "a" element with the "class" attribute set to "seo"

Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      |
    | content_editor  | 
    
Scenario: EMCs are not given the SEO tab
Given I am logged in as a user with the "edit_my_content" role
When I go to "admin/dashboard"
Then I should not see "User"
And I should not see "SEO"

# USERS WITH PROPER ROLE CAN VIEW THE SEO FUNCTIONALITY
@api 
Scenario Outline: Devs, SOs and CEs see the SEO Checklist populated with SEO functionality
Given I am logged in as a user with the <role> role
When I go to "admin/dashboard/seo"
Then I should see "Google Analytics"
And I should see "Site Verification"
And I should see "Link Checker"
And I should see "Site Description"
And I should see "Responsive/Mobile Friendly"
And I should see "Content Updated"

Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      |
    | content_editor  | 
    
#NOTE: EMCs DON'T GET ACCESS DENIED; THEY GET THE DASHBOARD
Scenario: EMCs cannot view SEO functionality
Given I am logged in as a user with the "edit_my_content" role
When I go to "admin/dashboard/seo"
Then I should not see "Google Analytics"
And I should not see "Site Verification"
And I should not see "Link Checker"
And I should not see "Site Description"
And I should not see "Responsive/Mobile Friendly"
And I should not see "Content Updated"

#VERIFY ACCESS TO SEO LINK CHECKER
@api 
Scenario Outline: only Devs, Admins and SEOs can access the SEO Link Checker
Given I am logged in as a user with the <role> role
When I go to "admin/settings/seo/linkchecker-analyze"
Then I should see <message>

Examples:
    | role            | message |
    | developer       | "Analyze your site content for links" |
    | administrator   | "Analyze your site content for links" |
    | site_owner      | "Analyze your site content for links" |
    | content_editor  | "Access denied" |
    | edit_my_content | "Access denied" |
    
#VERIFY THAT LINK CHECKER WORKS
@api
Scenario: the SEO Link Checker should work
Given I am logged in as a user with the "site_owner" role
When I go to "admin/settings/seo/linkchecker-analyze"
And I press "edit-linkchecker-analyze"
# Then I should see DON'T KNOW; BROKEN ON ALL SITES RIGHT NOW; DEF SHOULD NOT SEE THE FOLLOWING:
Then I should not see "unexpected error"

#VERIFY ACCESS TO GOOGLE ANALYTICS ACCOUNT ID PAGE
@api 
Scenario Outline: only Devs, Admins and SEOs can access the SEO Link Checker
Given I am logged in as a user with the <role> role
When I go to "admin/settings/site-configuration/google-analytics"
Then I should see <message>

Examples:
    | role            | message |
    | developer       | "Google Analytics Account IDs" |
    | administrator   | "Google Analytics Account IDs" |
    | site_owner      | "Google Analytics Account IDs" |
    | content_editor  | "Access denied" |
    | edit_my_content | "Access denied" |
    
#VERIFY THAT A GOOGLE ANALYTICS NUMBER CAN BE ADDED TO SITE
@api 
Scenario: A Google Analytics number can be added to site
Given I am logged in as a user with the "site_owner" role
When I go to "admin/settings/site-configuration/google-analytics"
And I fill in "edit-ga-account" with "UA-654321-1"
And I press "edit-submit"
Then I should see "The configuration options have been saved"
And the "edit-ga-account" field should contain "UA-654321-1"

#VERIFY ACCESS TO META TAG DESCRIPTION   
@api
Scenario Outline: only Devs, Admins and SEOs can access the Site Description setting
Given I am logged in as a user with the <role> role
When I go to "admin/settings/site-configuration/site-description"
Then I should see <message>

Examples:
    | role            | message |
    | developer       | "This text is added as a meta description for the site homepage." |
    | administrator   | "This text is added as a meta description for the site homepage." |
    | site_owner      | "This text is added as a meta description for the site homepage." |
    | content_editor  | "Access denied" |
    | edit_my_content | "Access denied" |
    
 
#VERIFY THAT ADDING A SITE DESCRIPTION POPULATES THE SITE DESCRIPTION META TAG   
@api
Scenario Outline: Adding text to site description populates Meta tag "Description" on site homepage
Given I am logged in as a user with the "site_owner" role
When I go to "admin/settings/site-configuration/site-description"
When I fill in "edit-site-description" with "My Amazing Site Description"
And I press "edit-submit"
And I go to "/"
Then the response should contain "content=\"My Amazing Site Description\""
  
@api  @broken
Scenario: Enabling SEO Bundle adds Meta Tags functionality to Basic Page
Given I am logged in as a user with the "site-owner" role
When I go to "node/page/add"
Then I should see the text "This text will be used by screen readers"
And I should see the link "Menu settings"
And I should see the link "Meta tags"
And I should see an "edit-metatags" element
And I should see an "#edit-metatags" element
