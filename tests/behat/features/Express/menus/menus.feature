@menus
Feature: Menus control the navigation structure of the site
When I go to the Admin/Menu page
As an authenticated user
I can add and edit the menus on my site
  
@api 
Scenario Outline: Most users see four installed menu types and two tabs
  Given I am logged in as a user with the <role> role
  When I go to "admin/structure/menu"
  Then I should see the link "List menus"
  And I should see the link "Settings"
  And I should see "Footer Menu"
  And I should see "Main menu"
  And I should see "Mobile Menu"
  And I should see "Secondary Menu"

  Examples:
  | role            | 
  | developer   |
  | administrator   |
  | site_owner      |
  | content_editor  |
    

@api
Scenario: A EMC should not be able to access the Menu page
  Given I am logged in as a user with the "edit_my_content" role
  When I go to "admin/structure/menu"
  Then I should see "Access denied"
    
 @api
 Scenario: An anonymous user should not be able to access the Menu page
   When I go to "admin/structure/menu"
   Then I should see "Access denied"
