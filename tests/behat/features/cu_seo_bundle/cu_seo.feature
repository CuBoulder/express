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

# USERS WITH PROPER ROLE CAN ACCESS SEO FUNCTIONALITY
@api 
Scenario Outline: The SEO Checklist should be populated with SEO functionality
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
    
#NOTE: THEY DON'T GET ACCESS DENIED; THEY GET THE DASHBOARD
Scenario: EMCs are cannot view SEO functionality
Given I am logged in as a user with the "edit_my_content" role
When I go to "admin/dashboard/seo"
Then I should not see "Google Analytics"
And I should not see "Site Verification"
And I should not see "Link Checker"
And I should not see "Site Description"
And I should not see "Responsive/Mobile Friendly"
And I should not see "Content Updated"

@api @seo
Scenario Outline: The SEO Link Checker should work
Given I am logged in as a user with the <role> role
When I go to "admin/settings/seo/linkchecker-analyze"
And I press "edit-linkchecker-analyze"
# Then I should see DON'T KNOW; BROKEN ON ALL SITES RIGHT NOW; DEF SHOULD NOT SEE THE FOLLOWING:
Then I should not see "unexpected error"

Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      |
    | content_editor  | 
    
@api @seo
Scenario Outline: A Google Analytics number can be added to site
Given I am logged in as a user with the <role> role
When I go to "admin/settings/site-configuration/google-analytics"
And I fill in "edit-ga-account" with "UA-654321-1"
And I press "edit-submit"
Then I should see "The configuration options have been saved"
And the "edit-ga-account" field should contain "UA-654321-1"

Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      |
    | content_editor  | 
    
@api @seo
Scenario Outline: Adding text to site description populates Meta tag "Description" on site homepage
Given I am logged in as a user with the <role> role
When I go to "admin/settings/site-configuration/site-description"
When I fill in "edit-site-description" with "My Amazing Site Description"
And I press "edit-submit"
And I go to "/"
Then the response should contain "content=\"My Amazing Site Description\""

Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      |
    | content_editor  | 
    
@api @seo @broken
Scenario Outline: The Meta Tags page functionality has been added to Basic Page
Given I am logged in as a user with the <role> role
When I go to "/"
And I follow "Edit"
Then I should see an "edit-metatags" element
And I should see an "#edit-metatags" element

Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      |
    | content_editor  | 
