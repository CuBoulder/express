@settings
Feature: URL redirects
In order to create vanity URLs or fix broken pages
An authenticated user with the proper role
Should be able to create a URL redirect

@api
Scenario Outline: Devs, Admins and SOs can view the URL redirects form
  Given I am logged in as a user with the <role> role
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
    
Examples:
    | role            | 
    | developer       | 
    | administrator   | 
    | site_owner      | 
    
Scenario Outline: Most users cannot access the URL Redirect Settings page
    Given I am logged in as a user with the <role> role
    When I go to "admin/config/search/redirect/settings"
    Then I should see <message>
      
    Examples:
    | role            | message         |
    | developer       | "Delete redirects that have not been accessed for" |
    | administrator   | "Access denied" |
    | site_owner      | "Access denied" |
    | content_editor  | "Access denied" |
    | edit_my_content | "Access denied" |
    
@api
Scenario Outline: Devs, Admins and SOs can create a URL redirect
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


# SOME ROLES CAN NOT CREATE A REDIRECT
@api 
Scenario Outline: CEs and EMCs can not create a URL redirect
Given I am logged in as a user with the <role> role
And am on "admin/config/search/redirect"
Then I should see "Access denied"

 Examples:
    | role            | 
    | content_editor  | 
    | edit_my_content  | 

@api 
Scenario: An anonymous user can not create a URL redirect
  When I am on "admin/config/search/redirect"
  Then I should see "Access denied"

@api
Scenario Outline: Devs, Admins and SOs can delete a URL redirect
  Given I am logged in as a user with the <role> role
  When I go to "admin/config/search/redirect/delete"
  Then I should see "Your site may contain redirects that have never been accessed." 
  And I click "edit-submit" 
 Then I should not see "The website encountered an unexpected error"
    
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
Scenario: An anonymous user can not access the 'delete URL redirect' page
  When I am on "admin/config/search/redirect/delete"
  Then I should see "Access denied"

