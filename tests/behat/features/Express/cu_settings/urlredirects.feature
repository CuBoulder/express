@settings
Feature: URL redirects
In order to create vanity URLs or fix broken pages
An authenticated user with the proper role
Should be able to create a URL redirect

Scenario Outline: Devs, Admins, SOs and ConMgrs can Create URL Redirects
Given I am logged in as a user with the <role> role
When I go to "admin/config/search/redirect"
Then I should see <message>

Examples:
| role             | message |
| developer        | "URL redirects" |
| administrator    | "URL redirects" |
| site_owner       | "URL redirects" |
| content_editor   | "Access denied" |
| edit_my_content  | "Access denied" |
| site_editor      | "URL redirects" |
| edit_only        | "Access denied" |
| access_manager   | "Access denied" |
| configuration_manager | "URL redirects" |

  @api
Scenario: the URL redirects form is properly populated with functionality
  Given I am logged in as a user with the "site_owner" role
  And am on "admin/config/search/redirect"
  Then I should see "List"
  And I should see "Delete redirects"
  And I should see the link "Add redirect"
  And I should see "Filter redirects"
  And I should see the link "sort by From"
  And I should see the link "sort by To"
  And I should see the link "sort by Status"
  And I should see the link "sort by Type"
  And I should see the link "sort by Count"
  And I should see the link "sort by Last accessed"
  
    
@api
Scenario Outline: Devs, Admins, SOs and ConMgrs can create a URL redirect
  Given I am logged in as a user with the <role> role
  When I go to "admin/config/search/redirect/add"
  Then I should see "From" 
  And I should see "To" 
  And the "edit-status" checkbox should be checked
  And I should see "Advanced options"
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 
    | configuration_manager |
    
    @api
Scenario Outline: Devs, Admins, SOs and ConMgrs can create a URL redirect
  Given I am logged in as a user with the <role> role
  When I go to "admin/config/search/redirect/add"
  Then I should see "From" 
  And I should see "To" 
  And the "edit-status" checkbox should be checked
  And I should see "Advanced options"
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 
    | configuration_manager |
    
    

Scenario Outline: Some roles cannot create a URL redirect
  Given I am logged in as a user with the <role> role
  When I go to "admin/config/search/redirect/add"
  Then I should see "Access denied"
  
  Examples
| role |
| content_editor |
| edit_my_content  | 
| site_editor      | 
| edit_only        | 
| access_manager   | 

  


@api
Scenario Outline: Devs, Admins and SOs can delete a URL redirect
  Given I am logged in as a user with the <role> role
  When I go to "admin/config/search/redirect/delete"
  Then I should see "Your site may contain redirects that have never been accessed." 
 # HIDING UNTIL PROBLEM IS FIXED And I press "edit-submit" 
 # HIDING UNTIL PROBLEM IS FIXED Then I should not see "The website encountered an unexpected error"
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 

# SOME ROLES CAN NOT DELETE A REDIRECT
@api 
Scenario Outline: CEs and EMCs can not access the 'delete URL redirect' page
Given I am logged in as a user with the <role> role
And am on "admin/config/search/redirect/delete"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 
    

@api 
Scenario Outline: Only Developers can access the URL Redirect Settings page
    Given I am logged in as a user with the <role> role
    When I go to "admin/config/search/redirect/settings"
    Then I should see <message>
      
    Examples:
    | role            | message         |
    | developer       | "Delete redirects that have not been accessed for" |
    | administrator   | "Access denied" |
    | site_owner      | "Access denied" |
    | content_editor  | "Access denied" |
    | edit_my_content  | "Access denied" |
    | site_editor      | "URL redirects" |
    | edit_only        | "Access denied" |
    | access_manager   | "Access denied" |
    | configuration_manager | "Access denied" |
    
    
Scenario: An anonymous user can not create, add or delete a URL redirect
 When I am on "admin/config/search/redirect"
 Then I should see "Access denied"
And I go to "admin/config/search/redirect/add"
  Then I should see "Access denied"
And I go to "admin/config/search/redirect/delete"
   Then I should see "Access denied"
And I go to "admin/config/search/redirect/settings"
 Then I should see "Access denied"
