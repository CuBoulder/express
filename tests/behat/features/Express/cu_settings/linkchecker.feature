@settings
Feature: Link Checker displays list of broken links
In order to find and fix broken links on my site
An authenticated user with the proper role
Should be able view the list of broken links

#SOME ROLES CAN VIEW LIST OF BROKEN LINKS
@api
Scenario Outline: Devs, Admins and SOs can view broken links
  Given I am logged in as a user with the <role> role
  And am on "admin/reports/linkchecker"
  Then I should see "Broken links"
  And I should see the link "sort by URL"
  And I should see the link "sort by Response"
  And I should see the link "sort by Error"
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

# SOME ROLES CAN NOT VIEW LIST OF BROKEN LINKS
@api 
Scenario Outline: CEs and EMCs should not be able to view broken links
Given I am logged in as a user with the <role> role
And am on "admin/reports/linkchecker"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
    
