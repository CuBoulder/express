@settings
Feature: Link Checker - Analyze Content checks a Web Express site for broken links
In order to find broken links on my site
An authenticated user with the proper role
Should be able to run the Link Checker

#SOME ROLES CAN VIEW LIST OF BROKEN LINKS
@api
Scenario Outline: All roles can run the Link Checker Analyzer
  Given I am logged in as a user with the <role> role
  And am on "admin/settings/seo/linkchecker-analyze"
  Then I should see "Analyze your site content for links"
  And I should see the link "Broken Links Report"
    
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
Scenario: An anonymous user should not be able to access the Link Checker Analyzer
  When I am on "admin/settings/seo/linkchecker-analyze"
  Then I should see "Access denied"
