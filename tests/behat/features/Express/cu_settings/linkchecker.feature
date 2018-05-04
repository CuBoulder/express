@settings
Feature: Link Checker displays list of broken links
In order to fix broken links on my site
An authenticated user with the proper role
Should be able to view the list of broken links

#SOME ROLES CAN VIEW LIST OF BROKEN LINKS
@api
Scenario Outline: All the roles can view broken links
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
    | configuration_manager |
    | content_editor |
    | edit_my_content  | 
    | site_editor      | 
    | edit_only        | 

@api 
Scenario: An anonymous user should not be able to view broken links
  When I am on "admin/reports/linkchecker"
  Then I should see "Access denied"
