# FOR MORE TESTS OF WEB EXPRESS STRUCTURE: 
# SEE ARTICLES FOR TAXONOMY TESTS
# SEE MENUS FOR MENUS TESTS
# SEE ADVANCED CONTENT FOR QUICKTABS TESTS

@structure
Feature: Structure section with links to context, manus, etc
When I go to the Admin/Structure page
As an authenticated user
I should be able to adjust the structure of my site
  
@api 
Scenario Outline: Some users see four links
  Given I am logged in as a user with the <role> role
  When I go to "admin/structure"
  Then I should see the link "Context"
  And I should see the link "Menus"
  And I should see the link "Quicktabs"
  And I should see the link "Taxonomy"

  Examples:
  | role            | 
  | administrator   |
  | site_owner      |
  | content_editor  |
  | site_editor |
    

@api
Scenario Outline:  Some users should not be able to access Admin/Structure
  Given I am logged in as a user with the <role> role
  And I am on "admin/structure"
  Then I should see "Access denied"
  
  Examples:
  | role            | 
  | edit_my_content   |
  | configuration_manager |
  | edit_only |
  | access_manager |
  | form_manager |
  
    
 @api
 Scenario: An anonymous user should not be able to access Admin/Structure
   When I am on "admin/structure"
   Then I should see "Access denied"
    
