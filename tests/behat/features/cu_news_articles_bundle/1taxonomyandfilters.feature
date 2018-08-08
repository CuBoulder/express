@newsArticles
Feature: Article Taxonomy
In order to group and filter my articles
As an authenticated user
I should be able to add taxonomy terms

Scenario: The Article Vocabularies are added to Structure/Taxonomy when bundle is enabled
Given I am logged in as a user with the "site_owner" role
And I am on "admin/structure/taxonomy"
Then I should see "Byline"
And I should see "Category"
And I should see "Tags"

Scenario: A Category Term can be added
Given I am logged in as a user with the "site_owner" role
And I am on "admin/structure/taxonomy/category/add"
And I fill in "Name" with "Academics"
And I press "Save"
Then I should see "Created new term Academics."

Scenario: A Tag Term can be added
Given I am logged in as a user with the "site_owner" role
And I am on "admin/structure/taxonomy/tags/add"
And I fill in "Name" with "Research"
And I press "Save"
Then I should see "Created new term Research."
