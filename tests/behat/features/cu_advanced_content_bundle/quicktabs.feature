#NOTE: TESTS FOR EDITING THE AN EXISTING QUICKTAB ARE FUNCTIONAL NOT AUTOMATED

@AdvContentBundle  @rebuild
Feature: the QuickTabs module has been deprecated
In order to transfer my content from QuickTabs to Expandable Block
As an authenticated user
I should be able to access the QuickTabs page but not add more of them
  
@api 
Scenario Outline: An user with the appropriate role can access QuickTabs page but not add any
  Given I am logged in as a user with the <role> role
  When I go to "admin/structure/quicktabs"
  Then I should see <message>
  And I should not see "Add Quicktabs Instance"

  Examples:
  | role            | message         |
  | edit_my_content | "Access denied" |
  | content_editor  | "Each Quicktabs instance has a corresponding block" |
  | site_owner      | "Each Quicktabs instance has a corresponding block" |
  | administrator   | "Each Quicktabs instance has a corresponding block" |
  | developer       | "Each Quicktabs instance has a corresponding block" |
  
@api 
Scenario: An anonymous user should not be able to access QuickTabs page
  Given I go to "admin/structure/quicktabs"
  Then I should see "Access denied"
  
@api 
# NOTE: THE QUICKTABS PAGE HAS A LINK TO THE BLOCKS ADMINISTRATION PAGE
Scenario Outline: Most users cannot access the Drupal System Block Admin page
  Given I am logged in as a user with the <role> role
  When I go to "admin/structure/block"
  Then I should see <message>
  
  Examples:
  | role            | message         |
  | edit_my_content | "Access denied" |
  | content_editor  | "Access denied" |
  | site_owner      | "This page provides a drag-and-drop interface" |  
  | administrator   | "Access denied" |
  | developer       | "This page provides a drag-and-drop interface" |  
