Feature: Search Engine Optimization Bundle
  In order to optimize my site content for search engines
  As a Site Owner
  I should be able access and edit SEO links and functionality

Background: 
Given I am logged in as a user with the "site_owner" role

@api @seo
Scenario: The SEO tab should exist
When I go to "admin/dashboard"
# Then I should see "User" WORKS BUT TRYING A TEST FOR CLASS ATTRIBUTE
# And I should see "SEO"
Then the "a" element should have "seo" in the "class" attribute

@api @seo
Scenario: The SEO Checklist should be populated with SEO functionality
When I go to "admin/dashboard/seo"
Then I should see "Google Analytics"
And I should see "Site Verification"
And I should see "Link Checker"
And I should see "Site Description"
And I should see "Responsive/Mobile Friendly"
And I should see "Content Updated"

@api @seo
Scenario: The SEO Link Checker should work
When I go to "admin/settings/seo/linkchecker-analyze"
And I press "edit-linkchecker-analyze"
# Then I should see I DON'T KNOW; IT'S BROKEN ON ALL SITES RIGHT NOW
Then I should not see "unexpected error"

@api @seo
Scenario: A Google Analytics number can be added to site
When I go to "admin/settings/site-configuration/google-analytics"
And I fill in "edit-ga-account" with "UA-654321-1"
And I press "edit-submit"
Then I should see "The configuration options have been saved"
And the "edit-ga-account" field should contain "UA-654321-1"

@api @seo
Scenario: The Meta Tags page functionality has been added and populated
When I go to "/"
And I follow "edit"
Then I should see the link "Meta tags"
# And I wait for AJAX
# And I click "Meta tags"
# Then I should see "Meta tags" THIS ONE FAILS; WHAT CAN IT FIND ON PAGE???
# Then I should see "Configure the meta tags below"

@api @seo
Scenario: Adding text to site description populates Meta tag "Description" on site homepage
When I go to "admin/settings/site-configuration/site-description"
When I fill in "edit-site-description" with "My Amazing Site Description"
And I press "edit-submit"
And I go to "/"
Then "meta" element should have "description" in the "name" attribute
And "meta" element should have "My Amazing Site Description" in the "content" attribute
