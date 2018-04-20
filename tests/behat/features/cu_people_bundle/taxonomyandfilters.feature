@people
Feature: People Taxonomy and Filters
In order to group and filter my people
As an authenticated user
I should be able to add taxonomy and rename filters

Scenario: The People Vocabularies have been added to the Taxonomy list
Given I am signed on as a "site_owner"
And I am on "admin/structure/taxonomy"
Then I should see "Department"
And I should see "Job Type"
And I should see "People Filter 1"
And I should see "People Filter 2"
And I should see "People Filter 3"
 
Scenario: The People Filter Labels can be renamed
Given I am signed on as a "site_owner"
And I am on "admin/settings/people/settings"
