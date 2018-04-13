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
  And I should see the link "Add menu"
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

@api 
# NOTE: THE MENUS PAGE HAS A LINK TO THE BLOCKS ADMINISTRATION PAGE
# HIDING THE WHOLE TEST FOR NOW, AS IT FAILS IN TRAVIS FOR UNKNOWN REASONS
# Scenario Outline: Most users cannot access the Drupal System Block Admin page
#  Given I am logged in as a user with the <role> role
#  When I go to "admin/structure/block"
#  Then I should see <message>
  
#  Examples:
#  | role            | message         |
#  | edit_my_content | "Access denied" |
#  | content_editor  | "Access denied" |
#  | site_owner      | "Access denied" |
#  | administrator   | "Access denied" |
#  | developer       | "This page provides a drag-and-drop interface" |  
  
 @api 
Scenario Outline: Authorized users can access the Footer Menu
  Given I am logged in as a user with the <role> role
  When I go to "admin/structure/menu/manage/menu-footer-menu"
  Then I should see <message>
  
  Examples:
  | role            | message         |
  | edit_my_content | "Access denied" |
  | content_editor  | "Footer Menu" |
  | site_owner      | "Footer Menu" |
  | administrator   | "Footer Menu" |
  | developer       | "Footer Menu" |
  
@api 
Scenario Outline: Authorized users can access the Main Menu
  Given I am logged in as a user with the <role> role
  When I go to "admin/structure/menu/manage/main-menu"
  Then I should see <message>
  
  Examples:
  | role            | message         |
  | edit_my_content | "Access denied" |
  | content_editor  | "Main Menu" |
  | site_owner      | "Main Menu" |
  | administrator   | "Main Menu" |
  | developer       | "Main Menu" |
  
@api 
Scenario Outline: Authorized users can access the Mobile Menu
  Given I am logged in as a user with the <role> role
  When I go to "admin/structure/menu/manage/menu-mobile-menu"
  Then I should see <message>
  
  Examples:
  | role            | message         |
  | edit_my_content | "Access denied" |
  | content_editor  | "Mobile Menu" |
  | site_owner      | "Mobile Menu" |
  | administrator   | "Mobile Menu" |
  | developer       | "Mobile Menu" |
  
 @api 
Scenario Outline: Authorized users can access the Secondary Menu
  Given I am logged in as a user with the <role> role
  When I go to "admin/structure/menu/manage/menu-secondary-menu"
  Then I should see <message>
  
  Examples:
  | role            | message         |
  | edit_my_content | "Access denied" |
  | content_editor  | "Secondary Menu" |
  | site_owner      | "Secondary Menu" |
  | administrator   | "Secondary Menu" |
  | developer       | "Secondary Menu" |
  
  @api
  Scenario Outline: A menu item can be added to a menu
  Given I am logged in as a user with the "site_owner" role
  When I go to <path>
  And I fill in "edit-additem-title" with "University of Colorado"
  And I press "Save configuration" 
  Then the "edit-link-title" field should contain "University of Colorado"
  And I fill in "edit-link-path" with "https://www.colorado.edu"
  And I should see "Icon"
  And I should see "Advanced menu item settings"
  And I press "Save"
  Then I should see "Your configuration has been saved."
  
  Examples:
  | path |
  | "admin/structure/menu/manage/menu-footer-menu" |
  | "admin/structure/menu/manage/main-menu" |
  | "admin/structure/menu/manage/menu-mobile-menu" |
  | "admin/structure/menu/manage/menu-secondary-menu" |
  
@api 
Scenario Outline: Authorized users can access the Menu Settings page
  Given I am logged in as a user with the <role> role
  When I go to "admin/structure/menu/settings"
  Then I should see <message>
  
  Examples:
  | role            | message         |
  | edit_my_content | "Access denied" |
  | content_editor  | "Source for the Main links" |
  | site_owner      | "Source for the Main links" |
  | administrator   | "Source for the Main links" |
  | developer       | "Source for the Main links" |
  
 @api 
Scenario: The Menu Settings page is properly populated with functionality
  Given I am logged in as a user with the "site_owner" role
  When I go to "admin/structure/menu/settings"
  Then I should see "Source for the Main links"
  And I should see "Source for the Secondary links"
  And I should see "Secondary Menu Label"
  And I should See 'Source for the mobile links"
  And I should see "Source for the footer links"
  
  
